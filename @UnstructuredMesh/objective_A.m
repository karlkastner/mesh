% Tue 25 Oct 10:21:49 CEST 2016
% Karl Kastner, Berlin
%
%% one objective function value per angle
%
% this can be used for least squares regression, as there are about twice as many angles as there are points,
% and two unknowns per point, however, the boundary vertices need to be parametrised as at most 1 coordinate (s)
%
% each triangle has three angles that are not shared,
% thus the objective function has 3*nelem rows
function [f g H] = objective_A(obj,fun,XY)
	if (size(obj.elem,2) ~= 3)
		error('Only applicable to triangulations');
	end

	T  = obj.elem(:,1:3);
	X  = XY(:,1);
	Y  = XY(:,2);
	Xt = X(T);
	Yt = Y(T);
%	Xt = obj.elemX;
%	Yt = obj.elemY;
	%bnd = obj.bnd1;
	% flat(obj.edge(obj.bnd,:));

	nt = obj.nelem;
	np = obj.np;

	% paranoid fix for 1-element meshes
	if (nt<2)
		Xt = rvec(Xt);
		Yt = rvec(Yt);
	end

	f    = [];
	gbuf = [];
	hbuf = [];

	%cosa0 = cos(rad2deg(60));
	f0 = obj.optimum_fun(obj);
	%[alpha0 cosa0] = obj.optimum_angle();

	% simultaneously for all triangles
	for idx=1:3
		% evaluate the objective function
		switch (nargout())
		case {1} % value only
			fi = fun(Xt,Yt,f0(T(:,1)));
			%fi = fun(Xt,Yt,cosa0(T(:,1)));
		case {2}
			% value and gradient
			[fi gi] = fun(Xt,Yt,f0(T(:,1)));
			%[fi gi] = fun(Xt,Yt,cosa0(T(:,1)));
		case {3} % value, gradient and hessian
			[fi gi hi] = fun(Xt,Yt,f0(T(:,1)));
			%[fi gi hi] = fun(Xt,Yt,cosa0(T(:,1)));
		end
		if (isnan(fi))
			f = NaN;
			H = NaN;
			g = NaN;
			return;
		end
		% place into buffer
		f  = [f;fi];
		if (nargout() > 1)
			% gradient buffer
			%gbuf = [gbuf;
                        %(1:nt)' + (idx-1)*nt,    T(:,1), gi.x(:,1);
                        %(1:nt)' + (idx-1)*nt,    T(:,2), gi.x(:,2);
                        %(1:nt)' + (idx-1)*nt,    T(:,3), gi.x(:,3);
                        %(1:nt)' + (idx-1)*nt, T(:,1)+np, gi.y(:,1);
                        %(1:nt)' + (idx-1)*nt, T(:,2)+np, gi.y(:,2);
                        %(1:nt)' + (idx-1)*nt, T(:,3)+np, gi.y(:,3)];
			gbuf = [gbuf;
                        (1:nt)' + (idx-1)*nt,    T(:,1), gi(:,1);
                        (1:nt)' + (idx-1)*nt,    T(:,2), gi(:,2);
                        (1:nt)' + (idx-1)*nt,    T(:,3), gi(:,3);
                        (1:nt)' + (idx-1)*nt, T(:,1)+np, gi(:,4);
                        (1:nt)' + (idx-1)*nt, T(:,2)+np, gi(:,5);
                        (1:nt)' + (idx-1)*nt, T(:,3)+np, gi(:,6)];
		if (nargout() > 2)
			% hessian buffer
			% (completition of lower triangular follows below)
			% as completition with H'+H, diagonal is halved
			hbuf = [hbuf;
				   T(:,1),   T(:,1),0.5*hi(:,1); %H(1,1)
				   T(:,1),   T(:,2),  hi(:,2); %H(1,2)
				   T(:,1),   T(:,3),  hi(:,3); %H(1,3)
				   T(:,1),T(:,1)+np,  hi(:,4); %H(1,4)
				   T(:,1),T(:,2)+np,  hi(:,5); %H(1,5)
				   T(:,1),T(:,3)+np,  hi(:,6); %H(1,6)
				   T(:,2),   T(:,2),0.5*hi(:,7); %H(2,2)
				   T(:,2),   T(:,3),  hi(:,8); %H(2,3)
				   T(:,2),T(:,1)+np,  hi(:,9); %H(2,4)
				   T(:,2),T(:,2)+np,  hi(:,10); %H(2,5)
				   T(:,2),T(:,3)+np,  hi(:,11); %H(2,6)
				   T(:,3),   T(:,3),0.5*hi(:,12); %H(3,3)
				   T(:,3),T(:,1)+np,  hi(:,13); %H(3,4)
				   T(:,3),T(:,2)+np,  hi(:,14); %H(3,5)
				   T(:,3),T(:,3)+np,  hi(:,15); %H(3,6)
				T(:,1)+np,T(:,1)+np,0.5*hi(:,16); %H(4,4)
				T(:,1)+np,T(:,2)+np,  hi(:,17); %H(4,5)
				T(:,1)+np,T(:,3)+np,  hi(:,18); %H(4,6)
				T(:,2)+np,T(:,2)+np,0.5*hi(:,19); %H(5,5)
				T(:,2)+np,T(:,3)+np,  hi(:,20); %H(5,6)
				T(:,3)+np,T(:,3)+np,0.5*hi(:,21); % H(6,6)
				];
		end % nargout > 2
		end % nargout > 1

		% circulate
		Xt = right(Xt);
		Yt = right(Yt);
		T  = right(T);
	end % for

	if (nargout() > 1)
		% construct sparse gradient matrix (dy stacked below dx)
		g = sparse(gbuf(:,1),gbuf(:,2),gbuf(:,3));
		%g = sparse(gbuf(:,1),gbuf(:,2),gbuf(:,3),3*nt,np);

		% apply special conditions at the boundary
		% TODO make boundary points univariate (functions in s (tangent))
		%if (~isempty(bnd))
		%	g(:,bnd) = 0;
		%	g(:,bnd+np) = 0;
		%end

		if (nargout() > 2)
			H = sparse(hbuf(:,1),hbuf(:,2),hbuf(:,3),2*np,2*np);
			% complete symmetry
			H = H+H';
		end % if nagout > 2
	end % if nargout > 1
end % objective_A

