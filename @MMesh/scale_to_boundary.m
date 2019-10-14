% Mo 30. Nov 08:49:07 CET 2015
% Karl Kastner, Berlin
%
% scale hierarchical mesh to match boundary coordinates
% experimental
%
function obj = scale_to_boundary(obj,xp,yp)
%	x0 = min(xp);
%	y0 = min(yp);
%	obj.point(:,1) = obj.point(:,1) - x0 + 1;
%	obj.point(:,2) = obj.point(:,2) - y0 + 1;
%	xp = xp-x0 + 1;
%	yp = yp-y0 + 1;
	

	% determine boundary condition
	% boundary segments
	% boundary points
	bnd = obj.edge(obj.bnd,:);
	pbnd = unique(bnd(:));
	id = knnsearch([cvec(xp) cvec(yp)], obj.point(pbnd,1:2));
%	id = knnsearch(obj.point(bnd,1:2),[cvec(xp) cvec(yp)]);

	% set up interpolation matrixd
	% build sparse matrix from edges
	A = sparse(obj.edge(:,1),obj.edge(:,2),ones(obj.nedge,1),obj.np,obj.np);
	A = A+A';
	% normalise rows
	A = diag(1./(sum(A,2)))*A;
	A = A - speye(size(A));
	% rhs
	b = zeros(obj.np,2);
	% boundary condition
	for idx=1:length(pbnd)
		p   = pbnd(idx);
		% set row to identity row
		A(p,:) = 0;
		A(p,p) = 1;
		% set rhs to scale
		b(p,1)   = xp(id(idx));
		b(p,2)   = yp(id(idx));
	end
	% solve system for scales
	tic
	s = A \ b;
	toc
	% scale coordinates
%	obj.point(:,1:2) = s.*obj.point(:,1:2);
	obj.point(:,1:2) = obj.point(:,1:2) + s;
%	obj.point(:,1) = obj.point(:,1) + x0 - 1;
%	obj.point(:,2) = obj.point(:,2) + y0 - 1;
end % scale_to_boundary

