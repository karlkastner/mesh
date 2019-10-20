% Mon  8 Aug 10:56:45 CEST 2016
% Karl Kastner, Berlin
%% integrate discharge
% TODO this should not be part of the mesh class or generalized
function [Q, A, qseg, aseg, edge2elem] = integrate_discharge(obj,path_,ed,depth,eu,ux,uy)
	path_ = cvec(path_);

	% get coordiantes of vertices along cross section
	XY = [cvec(obj.X(path_)), cvec(obj.Y(path_))];

	% get direction and distance of segments (edges) along path
	d = diff(XY);
	l = hypot(d(:,1),d(:,2));
	d = [d(:,1)./l, d(:,2)./l];

	% fetch edges and only keep edges not following the boundary
	edge      = obj.edge;
	edge2elem = obj.edge2elem();
	fdx       = all(edge2elem,2);
	edge2elem = edge2elem(fdx,:);
	edge      = edge(fdx,:);

	% find edge indices of path segments
	fdx = zeros(length(path_)-1,1);
	for idx=1:length(path_)-1
		fdxi = find(   (    (edge(:,1)  == path_(idx)) ...
			          & (edge(:,2)  == path_(idx+1)) ) ...
			    |  (    (edge(:,2)  == path_(idx)) ...
			          & (edge(:,1)  == path_(idx+1)) ) );
		if (numel(fdxi)>0)
			fdx(idx) = fdxi;
		else
			fdx(idx)   = 1;
			l(idx) = 0;
		end
	end
	%edge      = edge(fdx,:);
	edge2elem = edge2elem(fdx,:);

	if (size(ux,1) == obj.nelem)
		% velocity given at element centres
		% TODO, this should be done by solution of a linear system, with zero flow through the boundary
		ux   = 0.5*(ux(edge2elem(:,1),:) + ux(edge2elem(:,2),:));
		uy   = 0.5*(uy(edge2elem(:,1),:) + uy(edge2elem(:,2),:));

		% compute normal velocity
		un   = bsxfun(@times,ux,d(:,2)) - bsxfun(@times,uy,d(:,1));
	elseif (size(ux,1) == obj.np)
		% velocity given at vertices
		error('not yet impletemented');
	else
		% velocity given normal to edges (ux := un, uy := ut)

		% find edge indices of path segments as given in the parameter
		fdx = zeros(length(path_)-1,1);
		for idx=1:length(path_)-1
			fdxi = find(   (    (eu(:,1)  == edge2elem(idx,1)) ...
				          & (eu(:,2)  == edge2elem(idx,2)) ) ...
				    |  (    (eu(:,2)  == edge2elem(idx,1)) ...
			        	  & (eu(:,1)  == edge2elem(idx,2)) ) );
			if (numel(fdxi)>0)
				fdx(idx) = fdxi;
			else
				fdx(idx)   = 1;
				l(idx) = 0;
			end
		end
		un = ux(fdx,:);
	end

	% if depth is given at element centres, transform to edge-centres
	if (size(depth,1) == obj.nelem)
		% TODO, this should be done by solution of a linear system, with zero flow through the boundary
		depth   = 0.5*(depth(edge2elem(:,1),:) + depth(edge2elem(:,2),:));
	end
	
	% if depth is given at vertices, transform to edge centres
	% TODO

	% if depth is given at edges, bring edges to same order as in mesh
	% TODO

	% integrate segment area
	aseg = bsxfun(@times,l,depth);
max(max(aseg))

	% integrate over segments
	qseg = (aseg .* un);
	% integrate area along path
	A = (sum(aseg,1));

	% integratte along path
	Q = (sum(qseg,1));
end % integrate discharge

