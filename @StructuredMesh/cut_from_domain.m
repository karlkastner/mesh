% Thu 17 May 15:13:32 CEST 2018
% TODO if this is aplied before computing the sn-transform,
%      then 4-neighbourhood is sufficient
function [Dx,Dy,obj] = cut_from_domain(obj,cutfun)
	n = obj.n;
	nn = prod(n)*[1,1];

	Dx = obj.Dx;
	Dy = obj.Dy;

	% interior boundaries, for each removed point
	% TODO this might better go to the SMesh class
	flag = cutfun(obj.X,obj.Y);
	id   = find(flat(flag));
	obj.removed = id;
	[id1,id2] = ind2sub(n,id);

	% isolate removed points
	Dx(id,:)   = 0;
	Dx(sub2ind(nn,id,id))  = 1;
	Dy(id,:)   = 0;
	Dy(sub2ind(nn,id,id))  = 1;
	d = [-1,-1;
             -1, 0;
             -1,+1;
              0,-1;
              0,+1;
             +1,-1;
             +1, 0;
             +1,+1];
	% in curvilinear coordinates all 8-neighbours are non-zero
	for rdx=1:length(id)
	for ddx=1:size(d,1)
		id1_ = id1(rdx)+d(ddx,1);
		id2_ = id2(rdx)+d(ddx,2);
		if (    id1_ > 0 && id1_ <= n(1) ...
                     && id2_ > 0 && id2_ <= n(2) )
			jd = sub2ind(n,id1_,id2_);
			% constant extrapolation
			Dx(jd,jd) = Dx(jd,jd) + Dx(jd,id(rdx));
			Dy(jd,jd) = Dy(jd,jd) + Dy(jd,id(rdx));
			% decouple
			Dx(jd,id(rdx)) = 0;
			Dy(jd,id(rdx)) = 0;
		end % if
	end % for ddx
	% for rdx

if (0)
	% left neighbour
	%[n1,row,col] = obj.left(rid);
	n1 = rid-n(1);
	% if neighbour exists and is not removed
	fdx  = ~rflag(n1) & (col>0);
	n1   = n1(fdx);
	% second left neighbour
	% TODO check if inside domain
	%[n2,row,col] = obj.left(n1);
	n2 = n1-1;
%-> constant extrapolation in place, i.e. D(id,id) = D(id,id) + D(id,neighbour);
%this gets also rid of the 3 neighbour minimum
	Dx(sub2ind(nn,n1,n1)) = +1/dx;
	Dx(sub2ind(nn,n1,n2)) = -1/dx;
	
	% right neighbour
	[n1,row,col] = obj.right(rid);
	fdx  = ~rflag(n1) & (col<=nn(2));
	n1   = n1(fdx);
	% second right neighbour
	% TODO check if inside domain
	[n2,row,col] = obj.right(n1);
	Dx(sub2ind(nn,n1,n1)) =  -1/dx;
	Dx(sub2ind(nn,n1,n2)) =  +1/dx;

	% bottom neighbour
	[n1,row,col] = obj.down(rid);
	% if neighbour exists and is not removed
	fdx  = ~rflag(n1) & (row>0);
	n1   = n1(fdx);
	% second left neighbour
	% TODO check if inside domain
	[n2,row,col]          = obj.down(n1);
	Dy(sub2ind(nn,n1,n1)) = +1/dy;
	Dy(sub2ind(nn,n1,n2)) = -1/dy;

	% bottom neighbour
	[n1,row,col] = obj.up(rid);
	% if neighbour exists and is not removed
	fdx  = ~rflag(n1) & (row<=nn(1));
	n1   = n1(fdx);
	% second left neighbour
	% TODO check if inside domain
	[n2,row,col]          = obj.up(n1);
	Dy(sub2ind(nn,n1,n1)) = -1/dy;
	Dy(sub2ind(nn,n1,n2)) = +1/dy;
end

	obj.Dx = Dx;
	obj.Dy = Dy;
end % cut_from_domain

