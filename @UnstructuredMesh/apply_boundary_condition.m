% Mon 18 May 21:07:59 +08 2020
% 6.3
% TODO apply partial gaussian elimination during assembly to restore dirichlet conditions
% for eigenvalues, the symmetrization does only work for homogeneous dirichlet conditions
function [A,rhs] = apply_boundary_condition(obj,A,rhs,func,mode)
%	Xe    = reshape(obj.X(edge)[],2);
%	Ye    = reshape(obj.Y(edge)[],2);

	% number of test functions per triangle
	nt2 = 3;

	% degree of basis function poynomial
	% 1 for linear
	nv = 1;
	
	% vertex indices of boundary elements
	edge  = obj.edge(obj.bnd,:);
	tdx = obj.edge2elem(obj.bnd,1);
	T   = obj.elem(tdx,:);

	% element corner coordinates
	Xt = reshape(obj.X(T(:,1:3)),[],3); 
	Yt = reshape(obj.Y(T(:,1:3)),[],3);

	% boundary coordinates
	Xb = reshape(obj.X(obj.edge(obj.bnd,:)),[],2);
	Yb = reshape(obj.Y(obj.edge(obj.bnd,:)),[],2);

	% boundary midpoint
	Xbc   = mean(Xb,2);
	Ybc   = mean(Yb,2);

	id = (1:length(obj.bnd))';
	[p, val, bcid] = obj.match_boundary_condition(Xbc, Ybc, id, []);

	% boundary directions
%	t   = obj.edge_direction(bnd,true);
	% correct sign of tangent

	% baricentric coordinates and weights for numerical quadrature
	[w, b] = feval(obj.int1);

	% number of buffer entries per triangle
	%mb0 = nt2*(nt2+1)/2;
%	mb0 = nt2*nt2;

	% maximum number of elements in buffer after integration
%	nb0 = length(bnd)*mb0;

	% preallocate buffer
%	buf = zeros(nb0,3);
%	buf_ = zeros(nb0,3);
%	nb_ = 0;
	switch (mode)
		case {'lagrange'}
			bifun = @boundary_integral_lagrange;
		case {'hermite'}
			bifun = @boundary_integral_hermite;
		otherwise
			error('here');		
	end

	%nb = 0;
	% treat each boundary edge
	for tdx=1:length(obj.bnd)
	    if (p(tdx) < sqrt(eps)) 
	    	% Neumann
	    	if (val(tdx)~=0)
	    		% for du/dn=val=0, "natural" boundary conditions are automatically satisfied
	    		% otherwise set rhs (linear form) to 
	    		% -int_Gamma 1/(1-p) val v ds
			bifun(tdx,val(tdx));
	    	end
	    elseif ( p(tdx)>1-sqrt(eps) )
	    	% Dirichlet
	    	A(edge(tdx,:),:)           = 0;
	    	A(edge(tdx,1),edge(tdx,1)) = 1;
	    	A(edge(tdx,2),edge(tdx,2)) = 1;
	    	rhs(edge(tdx,:))           = val(tdx);
		% TODO set du/dt to zero for hermite?
	    	% TODO symmetrize, by partial gaussian elimination
	    else % robin (mixed)
	    	error('to be implemented')
	    	% int_G 1/(1-p) p u v to A
	    	% 	-int 1/(r-rho) val v ds to rhs
	    end
	end % for tdx

function boundary_integral_lagrange(tdx,du_dn)
		% corner vertices
		xp = Xt(tdx,:).';
		yp = Yt(tdx,:).';
		% boundary vertices
		xb = Xb(tdx,:).';
		yb = Yb(tdx,:).';

		% translate, for better conditioning
		xb = xb - xp(1);
		yb = yb - yp(1);
		xp = xp - xp(1);
		yp = yp - yp(1);

		% homogeneous edge coordinates
		% x_ = [0,l_(jdx)]';
		%A  = vander_1d(x_,1);
		Ax = vander_1d(xb,1);
		Ay = vander_1d(yb,1);

		% edge length
		length_ = hypot(diff(xb),diff(yb));

		% homogeneous cartesian coordinates of quadrature points
		qx = b*Ax;
		qy = b*Ay;

		% vandermonde matrix at corners
		% structure: [1 x y xy x^2 y^2]
		% A*c = rhs
		Va  = [   vander_2d(xp,yp,nv); ];

		% test/basis function evaulation weights (cubic)
		% rows: test functions, columns: weights
		% C(i,:) * A(:,i) = 1; C(i,:) * A(:,j) = 0, i<>j
		% note : this is already close to singular without rescaling
		C = inv(Va);

		% evaluate test function at the quadrature points
		% rows: function, columns: points
		Vq      = vander_2d(qx(:,2), qy(:,2), nv);

		% value at quadrature points
		phi     = Vq*C;
		
		% evaluate the coefficient function at the quadrature points
		% and premultiply values
		if (nargin() > 2 && ~isempty(func))
			wfa = length_*w.*feval(func,[qx(:,2),qy(:,2)]);
		else
			wfa = length_*w;
		end
		rhs = add_to_rhs(rhs,T(tdx,:),wfa,phi,du_dn);
end % boundary_integral_lagrange

end
