% Thu 17 May 15:33:22 CEST 2018
%% apply boundary condition and the four sides of the domain
%% TODO: allow for interior boudaries

function [A,rhs,mark] = apply_boundary_condition(obj,A,rhs,varargin)
	n  = obj.n;
	nn = prod(n)*[1,1];

	% left boundary
	id1      = obj.row(1);
	% TODO, quick hack, exclsion for corners, require special treatment
	id1 = id1(2:end-1);
	% get robin (mixed) boundary condition
	[p,v,bcid]  = obj.match_boundary_condition(obj.X(id1),obj.Y(id1),id1,varargin{:});
%	id1_ = id1(bcid>0);
	apply_boundary_condition_(id1, id1+1, ...
				       id1-n(1), ...
				       id1+n(1), ...
				       p,v); 
%	b(id1)        = rhs;
%	% right neighbour
%	id2       = obj.row(2);
%	A(id1,:)  = 0;
%	% dd : cartesian distance to neighbour
%	dd = hypot(obj.X(id1)-obj.X(id2),obj.Y(id1)-obj.Y(id2));
%	% flow is defined as inflow through boundary
%	A(sub2ind(nn,id1,id1)) = p - (1-p)./dd;
%	A(sub2ind(nn,id1,id2)) = +(1-p)./dd;
	mark = [id1,bcid];

	% right boundary
	id1      = obj.row(n(1));
	id1      = id1(2:end-1);
	% get robin (mixed) boundary condition
	[p,v,bcid]  = obj.match_boundary_condition(obj.X(id1),obj.Y(id1),id1,varargin{:});
	id1_ = id1(bcid>0);
	apply_boundary_condition_(id1, id1-1, ...
				       id1-n(1), ...
				       id1+n(1), ...
				       p,v); 

%	b(id1)   = rhs;
%	% left neighbour
%	id2       = obj.row(n(1)-1);
%	A(id1,:)  = 0;
%	% dd : cartesian distance to neighbour
%	dd = hypot(obj.X(id1)-obj.X(id2),obj.Y(id1)-obj.Y(id2));
%	% flow is defined as inflow through boundary
%	A(sub2ind(nn,id1,id1))  = p - (1-p)./dd;
%	A(sub2ind(nn,id1,id2)) = +(1-p)./dd;
	mark = [mark; id1,bcid];

	% bottom boundary
	id1      = obj.column(1);
	id1      = id1(2:end-1);
	% get robin (mixed) boundary condition
	[p,v,bcid]  = obj.match_boundary_condition(obj.X(id1),obj.Y(id1),id1,varargin{:});
%	id1_ = id1(bcid>0);
	apply_boundary_condition_(id1, id1+n(1), ...
				       id1-1, ...
				       id1+1, ...
				       p,v); 
%	b(id1)   = rhs;
%	% top neighbour
%	id2       = obj.column(2);
%	A(id1,:)  = 0;
%	% dd : cartesian distance to neighbour
%	dd = hypot(obj.X(id1)-obj.X(id2),obj.Y(id1)-obj.Y(id2));
%	% flow is defined as inflow through boundary
%	A(sub2ind(nn,id1,id1)) = p - (1-p)./dd;
%	A(sub2ind(nn,id1,id2)) = +(1-p)./dd;
	mark = [mark; id1,bcid];
	
	% top boundary
	id1      = obj.column(n(2));
	id1      = id1(2:end-1);
	% get robin (mixed) boundary condition
	[p,v,bcid]  = obj.match_boundary_condition(obj.X(id1),obj.Y(id1),id1,varargin{:});
%	b(id1)   = rhs;
%	% down neighbour
%	id2       = obj.column(n(2)-1);
%	A(id1,:)  = 0;
%	% dd : cartesian distance to neighbour
%	dd = hypot(obj.X(id1)-obj.X(id2),obj.Y(id1)-obj.Y(id2));
%	% flow is defined as inflow through boundary
%	A(sub2ind(nn,id1,id1)) = p - (1-p)./dd;
%	A(sub2ind(nn,id1,id2)) = +(1-p)./dd;
%	id1_ = id1(bcid>0);
	apply_boundary_condition_(id1,id1-n(1), ...
				       id1-1, ...
				       id1+1, ...
				       p,v); 
	mark = [mark; id1,bcid];

	% corner treatment
	A(1,:) = 0;
	A(1,1) = 1;
	A(1,2) = -2;
	A(1,3) = 1;
	A(n(1),:) = 0;
	A(n(1),n(1)) = 1;
	A(n(1),n(1)-1) = -2;
	A(n(1),n(1)-2) =  1;
	A(n(1)*(n(2)-1)+1,:) = 0;
	A(n(1)*(n(2)-1)+1,n(1)*(n(2)-1)+1) = 1;
	A(n(1)*(n(2)-1)+1,(n(1)*(n(2)-2)+1)) = -2;
	A(n(1)*(n(2)-1)+1,(n(1)*(n(2)-3)+1)) = 1;

	A(end,:) = 0;
	A(end,end)=1;
	A(end,end-1)=-2;
	A(end,end-2)=1;
	

	% quick and dirty
	b(obj.removed) = 0;

	u = unique(mark(:,2));
	u = u(u~=0);
	printf('Boundary condition set for %d boundaries:\n',length(u));
	for idx=1:length(u)
		n = sum(mark(:,2) == u(idx));
		fprintf('Boundary %d on %d points\n',u(idx),n);
	end

function apply_boundary_condition_(pid,qid,lid,rid,p,v)

	% L : left point
	% R : right point
	% P : point on boundary
	% Q : inner point

	xpq = obj.X(pid)-obj.X(qid);
	ypq = obj.Y(pid)-obj.Y(qid);
	xlr = obj.X(lid)-obj.X(rid);
	ylr = obj.Y(lid)-obj.Y(rid);
	% 
	dnc = hypot(xpq,ypq);
	dsc = hypot(xlr,ylr);
	b   = (   xpq.*ylr - ypq.*xlr )./(dsc.*dnc);
	a   = (   xpq.*xlr + ypq.*ylr )./(dsc.*dnc);
	% df/dbnd = (dsc*fP - dsc*fQ - a*dnc*fL + a*dnc*fR)/(b*dnc*dsc)
	% for orthogonal meshes : a = 0, b = 1 -> df/dbnd = (fP-fQ)/dnc
	A(pid,:) = 0;
	A(sub2ind(nn,pid,pid)) = (1-p).*( 1./(b.*dnc)) + p;
	A(sub2ind(nn,pid,qid)) = (1-p).*(-1./(b.*dnc));
	A(sub2ind(nn,pid,lid)) = (1-p).*(-a./(b.*dsc));
	A(sub2ind(nn,pid,rid)) = (1-p).*( a./(b.*dsc));
	rhs(pid)               = v;
%p
%	[ mean(b) mean(a) mean(dnc) mean(p) mean(v)]
end % apply_boundary_condition_

end

