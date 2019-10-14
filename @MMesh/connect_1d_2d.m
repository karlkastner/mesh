% Wed 30 Nov 11:07:07 CET 2016
% Karl Kastner, Berlin
% auto merge 1d and 2d mesh
% this silently requires that 1d segments consist at least of 3 elements
% TODO only implemented for triangles
function obj = connect_1d_2d(obj,dmax)
	% get 1d end points and last but 1 end point
	ep   = obj.bnd_1d();
	bnd  = obj.bnd;
	bnd2 = obj.edge(bnd,:);
	w    = obj.width_1d();
	bnd_elem = obj.edge2elem(obj.bnd,1);
	X = obj.X;
	Y = obj.Y;

	% bnd edge mid point
	Xc = mean(X(bnd2),2);
	Yc = mean(Y(bnd2),2);

	elem3 = obj.elemN(3);
	eX    = X(elem3);
	eY    = Y(elem3);
	flag  = false(size(ep,1),1);
	% for each end point
	for idx=1:size(ep,1)
%snap to bnd
%	-> find nearest bnd edge
%		edge length + elemen length
%	-> check if within range
%	-> connect to adjacent element
%	-> check if midpoints of neighbouring edge is closer than 1/2 w
%		-> connect too
%	->

		% TODO at best stupidly test triangles for containing point
		% find 2d boundary edges within 1/2 width range
		% TODO this should be distance point to line,
		% or distance to midpoint, but not twice point to point
		%d1   = hypot(X(ep(idx,1))-X(bnd2(:,1)),Y(ep(idx,1))-Y(bnd2(:,1)));
		%d1   = hypot(X(ep(idx,1))-X(bnd2(:,1)),Y(ep(idx,1))-Y(bnd2(:,1)));
		%d2   = hypot(X(ep(idx,1))-X(bnd2(:,2)),Y(ep(idx,1))-Y(bnd2(:,2)));
		%fdx  = find((d1 < w(ep(idx,1))) | (d2 < w(ep(idx,1))));
		%fdx  = find((d1 < w(idx)) | (d2 < w(idx)));
		%fdx = Geometry.inTriangle(eX,eY,X(ep(idx,1)),Y(ep(idx,1)));

		d           = hypot(X(ep(idx,1))-Xc,Y(ep(idx,1))-Yc);
		[dmin bndid] = min(d);
		if (dmin < dmax)
		%~isempty(fdx))
			% in case it is situated on the boundary between two elements
			edx = bnd_elem(bndid);
			%edx = fdx(1);
			% get incentre of associated elements
			%edx     = obj.edge2elem(fdx);
			[xc yc] = Geometry.tri_incircle(eX(edx,:),eY(edx,:));
			% replace end point by first incentre
			obj.point(ep(idx,1),1) = xc(1);
			obj.point(ep(idx,1),2) = yc(1);
			% TODO chain with neighbouring edges, if their midpoint is less than 1/2 w away


			% add remaining incentres
			%np = obj.np;
			%nc = length(xc)-1;
			%obj.point(np+(1:nc),1) = xc(2:end);
			%obj.point(np+(1:nc),2) = yc(2:end);
			% add 1d elements connecting incentres with last but 1 edge
			%obj.elem(end+(1:nc),1:2) = [(np+(1:nc))' ep(idx,2)*ones(nc,1)];
			flag(idx) = true;
		end % if ~isempty(fdx))
	end % for idx

	fprintf('Connected %d of %d 1d end points\n',sum(flag),length(flag));
	
	obj.edges_from_elements();
end % connect_1d_2d

