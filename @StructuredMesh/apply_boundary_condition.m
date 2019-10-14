% Thu 17 May 15:33:22 CEST 2018
% TODO, what should be done at the corners?
function [A,b] = apply_boundary_condition(obj,A,b,bcfun,varargin)
	n  = obj.n;
	nn = prod(n)*[1,1];

	% left boundary
	id1      = obj.row(1);
	% get robin (mixed) boundary condition
	[p,rhs]  = bcfun(obj.X(id1),obj.Y(id1),id1,varargin{:});
	b(id1)   = rhs;
	% right neighbour
	id2       = obj.row(2);
	A(id1,:)  = 0;
	% dd : cartesian distance to neighbour
	dd = hypot(obj.X(id1)-obj.X(id2),obj.Y(id1)-obj.Y(id2));
	% flow is defined as inflow through boundary
	A(sub2ind(nn,id1,id1)) = p - (1-p)./dd;
	A(sub2ind(nn,id1,id2)) = +(1-p)./dd;

	% right boundary
	id1      = obj.row(n(1));
	% get robin (mixed) boundary condition
	[p,rhs]  = bcfun(obj.X(id1),obj.Y(id1),id1,varargin{:});
	b(id1)   = rhs;
	% left neighbour
	id2       = obj.row(n(1)-1);
	A(id1,:)  = 0;
	% dd : cartesian distance to neighbour
	dd = hypot(obj.X(id1)-obj.X(id2),obj.Y(id1)-obj.Y(id2));
	% flow is defined as inflow through boundary
	A(sub2ind(nn,id1,id1))  = p - (1-p)./dd;
	A(sub2ind(nn,id1,id2)) = +(1-p)./dd;

	% bottom boundary
	id1      = obj.column(1);
	% get robin (mixed) boundary condition
	[p,rhs]  = bcfun(obj.X(id1),obj.Y(id1),id1,varargin{:});
	b(id1)   = rhs;
	% top neighbour
	id2       = obj.column(2);
	A(id1,:)  = 0;
	% dd : cartesian distance to neighbour
	dd = hypot(obj.X(id1)-obj.X(id2),obj.Y(id1)-obj.Y(id2));
	% flow is defined as inflow through boundary
	A(sub2ind(nn,id1,id1)) = p - (1-p)./dd;
	A(sub2ind(nn,id1,id2)) = +(1-p)./dd;
	
	% top boundary
	id1      = obj.column(n(2));
	% get robin (mixed) boundary condition
	[p,rhs]  = bcfun(obj.X(id1),obj.Y(id1),id1,varargin{:});
	b(id1)   = rhs;
	% down neighbour
	id2       = obj.column(n(2)-1);
	A(id1,:)  = 0;
	% dd : cartesian distance to neighbour
	dd = hypot(obj.X(id1)-obj.X(id2),obj.Y(id1)-obj.Y(id2));
	% flow is defined as inflow through boundary
	A(sub2ind(nn,id1,id1)) = p - (1-p)./dd;
	A(sub2ind(nn,id1,id2)) = +(1-p)./dd;

	% quick and dirty
	b(obj.removed) = 0;
end % apply_boundary_condition

