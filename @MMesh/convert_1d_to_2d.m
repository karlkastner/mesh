% Wed 30 Aug 16:34:04 CEST 2017
% rather than meshing, this is a 1:1 transformation of elements
% end points of 1d elements (segments) are stretched to faces (edges)
function obj = convert_1d_to_2d(obj)

	
		% 1d elements
		[elem id] = obj.elemN(2);

		% split 1d elements, that connect bifurcations,
		% as at least 2 elements are required between bifurcations

		% number of neighbours per point
		nn = accumarray(elem(:),ones(2*size(elem,1),1),[obj.np,1]);
		flag = (nn>2);
		sid = id(all(flag(elem),2));
		obj.split_elem_1d(sid);
		clear nn flag sid elem id

		% refetch
		[elem id] = obj.elemN(2);

		% element centres
		ecXY = obj.element_midpoint();
		%[ecX ecY] = 
		ecX = ecXY(:,1);
		ecY = ecXY(:,2);

		% valence of points (number of neighbours)
		nn  = zeros(obj.np,1);
		% point to element index
		p2e = zeros(obj.np,3);

		% for each element
		for idx=1:size(elem,1)
			% increas counter
			nn(elem(idx,1))     = nn(elem(idx,1)) + 1;
			p2e(elem(idx,1),nn(elem(idx,1))) = id(idx);
			nn(elem(idx,2))     = nn(elem(idx,2)) + 1;
			p2e(elem(idx,2),nn(elem(idx,2))) = id(idx);
		end
		% only select points, associated with 1d and with less than 3 neighbours
		pdx = (nn>0) & (nn<3);

		% width at points
		W = obj.pval.width(pdx);

		dX = zeros(obj.np,2);
		dY = zeros(obj.np,2);

		% in case of 1 associated element (terminal)
		% direction is in direction of element
		fdx     = (1==nn);
		eX      = obj.elemX(p2e(fdx,1));
		eY      = obj.elemY(p2e(fdx,1));
		dX(fdx) = eX(:,2) - eX(:,1);
		dY(fdx) = eY(:,2) - eY(:,1);

		% terminal points connecting to the 2d mesh
		XYb = obj.edge_midpoint(obj.bnd);
		l   = obj.edge_length(obj.bnd);
		[bid dis] = knnsearch(XYb(:,1:2),[obj.X(fdx),obj.Y(fdx)],'K',1);

		% 1d terminal vertices connecting to a 2d element
		isbnd         = false(obj.np,1);
		flag          = (dis < (l(bid)+obj.pval.width(fdx)));
		isbnd(fdx)    = flag;
		P_bnd         = obj.edge(obj.bnd(bid(flag)),:);
		
		% 1d points associated with 2 elements,
		% for points on faces associated with two elements,
		% direction is in line connecting mid-points
		fdx = (2==nn);

		% direction in case of two neighbours
		% left and right element centres
		% each of the 1d points becomes associated with two 2d points,
		% except at junctions and terminals and isolated elements
		% this is identically to determining the local slope with hermite polynomials
		dX(fdx) = ecX(p2e(fdx,2)) - ecX(p2e(fdx,1));
		dY(fdx) = ecY(p2e(fdx,2)) - ecY(p2e(fdx,1));
		
		% normalise direction
		l = hypot(dX,dY);
		dX = dX./l;
		dY = dY./l;

		% new point pair of the face replacing the old point
		% TODO, this has actually to be scaled 1/cos interior angle (times 1.4 in 90 deg connections)
		Xfc = obj.X(pdx);
		Yfc = obj.Y(pdx);
		Xf  = [Xfc + 0.5*W.*dY(pdx), Xfc - 0.5*W.*dY(pdx)];
		Yf  = [Yfc - 0.5*W.*dX(pdx), Yfc + 0.5*W.*dX(pdx)]; 
		% take over depth
		Zf = obj.Z(pdx)*[1 1];

		n = sum(pdx);
		% add new points
		np = obj.np;
		%obj.point(np+1:np+2*n,1:2) = [flat(Xf),flat(Yf)];
		obj.add_vertex(flat(Xf),flat(Yf),flat(Zf));

		% add new elements
		P    = np+[(1:n)', (n+1:2*n)'];		

		% find elements that have two neighbours
		edx  = all(pdx(elem),2);
		ne   = sum(edx);
		P_   = zeros(np,2);
		P_(pdx,:) = P;

		% substitute terminal points by bnd points
		P          = P_;
		P(isbnd,:) = P_bnd;

		enew = [P(elem(edx,1),:),P(elem(edx,2),:)];
		obj.elem(end+1:end+ne,1:4) = enew;

		r_edx = id(edx);

		% bifuractions:
		% the point at the centre is removed, and instead the 6 points of the adjacent elements are used
		pdx = find(3==nn);

		% get the 3 elements connecting to these points
		edx   = p2e(pdx,1:3);
		e = [];
		elem_ = double(obj.elem);
		for idx=1:3
			e(:,idx)     = (elem_(edx(:,idx),1).*(elem_(edx(:,idx),1) ~= pdx) ...
			                + elem_(edx(:,idx),2).*(elem_(edx(:,idx),2) ~= pdx));
		end

		% get the three faces associated with these points
		enew = [P(e(:,1),:),P(e(:,2),:),P(e(:,3),:)];
		fdx_ = all(enew,2);
		enew = enew(fdx_,:);
		ne   = size(enew,1);

		r_edx = [r_edx; flat(edx(fdx_,:))];

		% add element
		obj.elem(end+1:end+ne,1:6) = enew;

		% remove centreal point
		% obj.remove_points(pdx);

		% remove the 3 1d elements
		%obj.delete_element(flat(edx));

		% remove old elements
		obj.delete_element(r_edx);

		% remove old points
		obj.remove_isolated_vertices();
	
		obj.uncross_elements;
		obj.make_elements_ccw();
end % function convert_1d_to_2d

