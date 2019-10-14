% Mo 28. Sep 14:16:30 CEST 2015

function [bc, obj] = grid_block(obj,bc)
	% number of rows (eta)
	if (isfield(bc,'bottom'))
		Ne = length(bc.bottom.X);
	elseif (isfield(bc,'south'));
		Ne = length(bc.south.X);
	else
		error('Cannot detmerin width');
	end
	% TODO verify length
%	if (length(X0.top) ~= Ne)
%		% TODO check also y
%		error('bottom and top must be of equal length');
%	end
	
	% number of columns (chi)
	if (isfield(bc,'left'))
		Nc = length(bc.left.X);
	elseif(isfield(bc,'west'))
		Nc = length(bc.west.X);
	else
		error('Cannot detmerin height');
	end
	% TODO check other length
	
	% step size
	de = 1/(Ne+1);
	dc = 1/(Nc+1);
	
	% initial condition (interpolated)

	X0 = [];
	Y0 = [];
	E0 = [];
	C0 = [];
	field_C = {'north','east','south','west'};
	% fieldnames(bc);
	for idx=1:length(field_C)
		bc0 = bc.(field_C{idx});
		C0 = [C0; cvec(bc0.cdx)];
		E0 = [E0; cvec(bc0.edx)];
		X0 = [X0; cvec(bc0.X)];
		Y0 = [Y0; cvec(bc0.Y)];
	end% for idx
	E = repmat(1:Nc,Ne,1);
	C = repmat((1:Ne)',1,Nc);
	interp = TriScatteredInterp(C0+1,E0,X0,'natural');
	X = interp(E,C);
	interp = TriScatteredInterp(C0+1,E0,Y0,'natural');
	Y = interp(E,C);

	% initial condition (regular grid)
%	Y = repmat(1:Nc,Ne,1);
%	X = repmat((1:Ne)',1,Nc);

%	if (dbplot)
%		clf
%			plot(X0,Y0,'ok')
%		plot(X,Y,'.-');
%		hold on
%		plot(X',Y','.-');
%		for idx=1:1:Ne
%			for jdx=1:Nc
%				text(X(idx,jdx),Y(idx,jdx),num2str(idx));
%			end % for jdx
%		end % for idx
%		pause()
%	end % if dplot

	X = flat(X);
	Y = flat(Y);
	XY = [X;Y];

	% rhs
	BX = zeros(Nc*Ne,1);
	BY = zeros(Nc*Ne,1);
	
	% this is a boundary value problem
	% this is a non-linear elliptic pde, solution approximated iteratively
	it  = 0;
	while (true)
		X_ = reshape(X,Ne,Nc);
		Y_ = reshape(Y,Ne,Nc);
%		if (dbplot)
%		plot(X_,Y_,'.-');
%		hold on
%		plot(X_',Y_','.-');
%		end

%	for idx=1:10:Ne
%		for jdx=1:Nc
%			text(X_(idx,jdx),Y_(idx,jdx),num2str(idx));
%		end
%	end

%		pause(1)

		% set up pde system
		
		% derivatives
		Dc =  spdiags((0.5/dc)*ones(Ne,1)*[-1, 1],[-1, 1],Ne,Ne);
		Dc =  kron(speye(Nc),Dc);
		De =  spdiags((0.5/de)*ones(Nc,1)*[-1, 1],[-1, 1],Nc,Nc);
		De =  kron(De,speye(Ne)); %,De);
%		De =  spdiags((0.5/de)*ones(Ne*Nc,1)*[-1, 1],[-1, 1],Ne*Nc,Ne*Nc);
%		Dc =  spdiags((0.5/dc)*ones(Ne*Nc,1)*[-1, 1],[-Ne, Ne],Ne*Nc,Ne*Nc);
	
		% make it a block matrix
		Z  = spzeros(Ne*Nc,Ne*Nc);
	
		% first derivatives
		Xe = De*X;
		Xc = Dc*X;
		Ye = De*Y;
		Yc = Dc*Y;
	
		% factors (these make the PDE non-linear)
		% TODO, this swaps alpha and gamma as specified in the book
		gamma = (Xe).^2 + (Ye).^2;
		alpha = (Xc).^2 + (Yc).^2;
		beta  = (Xc.*Xe) + (Yc.*Xe);
		alpha_ = alpha;
		alpha = gamma;
		gamma = alpha_;

		alpha = diag(sparse(alpha));
		gamma = diag(sparse(gamma));
		beta  = diag(sparse(beta));
	
		% second derivatives
%		Dcc = (1/dc^2)*spdiags(ones(Ne*Nc,1)*[1, -2, 1],[-1:1],Ne*Nc,Ne*Nc);
%		Dce = -Dc*De;
%		Dee = (1/de^2)*spdiags(ones(Ne*Nc,1)*[1, -2, 1],[-Ne,0,Ne],Ne*Nc,Ne*Nc);
		Dcc = (1/dc^2)*spdiags(ones(Ne,1)*[1, -2, 1],[-1:1],Ne,Ne);
		Dcc = kron(speye(Nc),Dcc);
		Dee = (1/de^2)*spdiags(ones(Nc,1)*[1, -2, 1],[-1,0,1],Nc,Nc);
		Dee = kron(Dee,speye(Ne));
		Dce = De*Dc;
%		norm(full(De*Dc-Dc*De))
%kron(De,speye(Ne))*kron(speye(Nc),Dc);
%		Dce = -Dc*De;
	
		% discretisation matrix
		A = [alpha*Dcc - 2*beta*Dce + gamma*Dee];
	
		AX = A;
		AY = A; 
	
		%
		% apply boundary conditions
		% TODO, verify, that for all boundary points a bc is set
		%
	
		%field_C = fieldnames(bc);
		field_C = {'north','east','south','west'};
		for idx=1:length(field_C)
			bc0 = bc.(field_C{idx});
			ddx = Ne*bc0.cdx + bc0.edx;
			idx = sub2ind([Ne*Nc, Ne*Nc],ddx,ddx);
			AX(ddx,:)   = 0;
			AX(idx)     = 1;
			AY(ddx,:)   = 0;
			AY(idx)     = 1;
			BX(ddx)     = bc0.X;
			BY(ddx)     = bc0.Y;
%			if (dbplot)
%				hold on
%				plot(bc0.X,bc.Y,'.-k');
%				hold off
%			end
		end
		% TODO del, delete part of the (unused mesh)

%		if (dbplot)
%			pause(1);
%		end
	
		% assemble matrix	
		A = [AX, Z; Z, AY];

		% assemble right hand side
		B = [BX; BY];
	
%		XY_ = gmres(A,B);
%		XY_ = A \ B;
		%p = amd(A);
		p = colamd(A);
		XY_ = A(:,p) \ B;
		XY_(p) = XY_;

		minval = max(abs(XY_ - XY))
		XY = XY_;
	
		X = XY(1:Ne*Nc);
		Y = XY(Ne*Nc+1:end);

		% check for convergence
		if (minval < obj.abstol)
			break;
		end
		% check for maximum number of iterations
		it = it+1;
		if (it > obj.maxit)
			warning('No convergence');
			break;
		end
	
	end % while no convergence

	% retransform to real world variables
	% TODO

	% write data to block
	bc.E = E;
	bc.C = C;
	bc.X = reshape(X,Ne,Nc);
	bc.Y = reshape(Y,Ne,Nc);
end % grid_block

