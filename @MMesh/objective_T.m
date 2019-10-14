% Tue 25 Oct 18:59:57 CEST 2016
% Karl Kastner, Berlin
%
% wrapper for mesh optimisation objective functions univariate in triangles
%
function [f g] = objective_T(obj,fun)
	if (size(obj.elem,2) ~= 3)
		error('Only applicable to triangulations');
	end

	T  = obj.elem(:,1:3);
	Xt = obj.elemX;
	Yt = obj.elemY;
	bnd = flat(obj.edge(obj.bnd,:));

	nt = obj.nelem;
	np = obj.np;

	% fix for 1-element meshes
	if (nt<2)
		Xt = rvec(Xt);
		Yt = rvec(Yt);
	end

	% simultaneously for all triangles
	if (nargout() < 2)
		% objective function value and derivative
		[f]   = fun(Xt,Yt);
	else
		[f g] = fun(Xt,Yt);

		% place in to buffer
		% each triangle has three angles that are not shared
		gbuf = [(1:nt)',    T(:,1), g.x(:,1);
                        (1:nt)',    T(:,2), g.x(:,2);
                        (1:nt)',    T(:,3), g.x(:,3);
                        (1:nt)', T(:,1)+np, g.y(:,1);
                        (1:nt)', T(:,2)+np, g.y(:,2);
                        (1:nt)', T(:,3)+np, g.y(:,3)];

		% construct sparse gradient matrix (dy stacked below dx)
		g = sparse(gbuf(:,1),gbuf(:,2),gbuf(:,3));
		%g = sparse(gbuf(:,1),gbuf(:,2),gbuf(:,3),3*nt,np);

		% project boundary points
		% TODO gradient projection
		% TODO make boundary points univariate (functions in s (tangent))
		if (~isempty(bnd))
			g(:,bnd) = 0;
			g(:,bnd+np) = 0;
		end
	end
end % objective_T

