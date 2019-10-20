% Mon 26 Sep 16:11:50 CEST 2016
%% point has connectivity 4 and is not on the boundary
function obj = remove_quartered_triangles(obj)
	if (obj.nedge ~= obj.nedge_)
		disp('Recomputing edges');
		obj.edges_from_elements();
	end

	% this is done iteratively, because changes can trigger new changes
	while (1)
	np = obj.np();
	
	% find vertices with 4 neighbours
	A   = obj.vertex_to_vertex();
	pdx = (4==sum(A));
	% exclude vertices on the boundary
	bnd = obj.edge(obj.bnd,:);
	pdx(bnd(:)) = false;
	% exclude 1d elements
	elem2 = obj.elemN(2);
	if (~isempty(elem2))
		pdx(elem2(:)) = false;
	end
	pdx = find(pdx);
	dedx = [];
	dpdx = [];
	tflag = false(obj.nelem,1);
	% TODO, this only works if the covering quadrilateral is convex, assumed here
	for idx=1:length(pdx)
		% find all triangles containing the vertex to be removed
		tdx = find(any(obj.elem(:,1:3) == pdx(idx),2));

		% no dublicate processing
		% TODO reiterate if this is the case
		if (any(tflag(tdx)))
			continue;
		end
		if (4 ~= length(tdx))
			error('here')
		end

		tflag(tdx) = true;

		% neighbouring vertices
		p    = find(A(:,pdx(idx)));
		elem = obj.elem(tdx,:);


		% remove vertex
		elem = unique(elem(elem ~= pdx(idx)));

		% retriangulate
		T = delaunay(obj.X(elem),obj.Y(elem));
		if (size(T,1) > 2)
			% not convex
			continue;
		end

		% local to global coordinates
		T = elem(T);
		% replace first two elements
		obj.elem(tdx(1:2),1:3) = T;

		% mark point for removal
		dpdx = [dpdx; pdx(idx)];

		% mark elements for removal
		dedx = [dedx; tdx(3:4)];

	end % for idx
	% remove remaining triangles
	obj.delete_element(dedx);
	%obj.elem(dedx,:) = [];
	% remove remaining points
	fprintf(1,'Removing %d fourfold connected points\n',length(dpdx));
	obj.remove_points(dpdx);
	% lazy recomputation
	obj.edges_from_elements();
	if (obj.np==np)
		break;
	end % if obj.np == np
	end % while true
end % remove_quatered_triangles

