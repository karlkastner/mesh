% Di 27. Okt 03:10:12 CET 2015
% Karl Kastner, Berlin
%
%% edges and boundaries from elements
%
% TODO distinguish quadrilaterals (2d) and tetras (3d)
function obj = edges_from_elements(obj)
	% for triangles and rectangles
	ne = numel(obj.elem);

	edge      = [];
	edge2elem = [];
	side      = [];
	%elem2edge = [];

	% for each polygons (triangles, quadrialaterals, ...)
	k = 0;
	% 2-point elements are for 1d-meshes
	for idx=2:size(obj.elem,2)
		[elemN fdx] = obj.elemN(idx);
		n          = size(elemN,1);
		if (0 == n)
			continue;
		end
		edgei      = zeros(n*idx,2);
		edge2elemi = zeros(n*idx,1);
		sidei      = zeros(n*idx,1);
		% for each side
		for jdx=1:idx-1
			% index into edge
			id                  = (jdx-1)*n + (1:n)';
			% vertices of edge
			edgei(id,:)         = [elemN(:,jdx), elemN(:,jdx+1)];
			% element index
			edge2elemi(id,1)    = fdx;
			% side of element
			sidei(id,1)         = jdx;
			%elem2edgei(fdx,jdx) = id;
		end % for jdx
		% last side by connecting last with first vertex
		id                  = (idx-1)*n + (1:n)';
		edgei(id,:)         = [elemN(:,idx) elemN(:,1)];
		edge2elemi(id,1)    = fdx;
		sidei(id)           = idx;

		% for triangles, sides are expected to face the point
		if (3 == idx)
			sidei = mod(sidei+1,3)+1;
		end
          
		% store
		edge             = [edge;edgei];
		edge2elem        = [edge2elem; edge2elemi];
		side             = [side; sidei];
		k = k + n*idx;
	end % for idx

	% truncate to actual size
	edge      = edge(1:k,:);
	edge2elem = edge2elem(1:k,:);
	side      = side(1:k);

	% sort edges
	edge       = sort(edge,2);
	[edge,sdx] = sortrows(edge);
	edge2elem  = edge2elem(sdx,:);
	side       = side(sdx);
	%edge2elem   = edge2elem(ia,:);
	% TODO sort elem2edge
%	elem2edge   = ic(elem2edge);

	% build inverse index
%	edge2elem  = zeros(size(edge,1),2);
%	N = zeros(size(edge,1),1);
%	for idx=1:3
%		
%		edge2elem(elem2edge(
%	end

	% iterior sides exist twice
	fdx       = find([false;0==(abs(diff(edge(:,1)))+abs(diff(edge(:,2))))]);
%
	% take over second index
%	id = (1:size(edge,1));
	edge2elem(fdx-1,2) = edge2elem(fdx,1);
	side(fdx-1,2)      = side(fdx,1);
	% edge2elem          = sort(edge2elem,2,'descend');

%	% remove dubplicates
	edge(fdx,:)        = [];
	edge2elem(fdx,:)   = [];
	side(fdx,:)        = []; % ?

	% inverse index
	elem2edge = zeros(size(obj.elem));
	for idx=1:2
		fdx = find(0~=edge2elem(:,idx));
		id  = sub2ind(size(obj.elem),edge2elem(fdx,idx),side(fdx,idx));
		elem2edge(id) = fdx;
	end
%	elem2edge = reshape(elem2

%	% other functions expect the sides to face the point, rotate
%	% TODO quick fix, this is not well defined when there are also quads
%	if (3==size(obj.elem,2))
%		elem2edge = left(elem2edge);
%	end

	obj.compute_elem2elem();

	% find boundaries
	bnd = find(0 == edge2elem(:,2));

	% boundary vertices
	bnd1 = unique(flat(edge(bnd,:)));

	% Thu  9 Jun 17:14:11 CEST 2016
	% boundary chain (bidirectional)
	% point index pairs of boundary segments
	bnd2 = edge(bnd,:);

	% stack boundary edges in both directions (forward and backward)
	% each boundary vertex has exactly two neighbours, which have consecuitve rows when being sorted
	buf  = [bnd2; % forward
                bnd2(:,2),bnd2(:,1)]; % backward
	buf  = sortrows(buf);
	% together with the vertex itself, they give a neighbour triple
	% centre, left, right (left and right arbitrary (not guaranteed cw/ccw)
	bnd3 = [buf(1:2:end,1:2), buf(2:2:end,2)];

	% write back
	obj.bnd       = bnd;
	obj.bnd1      = bnd1;
	obj.bnd3      = bnd3;

	% note, this is only the come first triangle, but unique at the boundary
	obj.edge2elem = edge2elem;
	obj.elem2edge = elem2edge;
	
	obj.edge      = edge;
end % edges_from_elements

