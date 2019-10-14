% Wed 28 Sep 14:59:02 CEST 2016
% Karl Kastner, Berlin
function obj = remove_triply_connected_boundary_vertices(obj)
	% determine boundary vertices with just 3 neighbours
	pdx = unique(flat(obj.edge(obj.bnd,:)));
	n   = sum(obj.vertex_connectivity());
	pdx = pdx(3 == n(pdx));
	% for each point
	dpdx = [];
	dtdx = [];
	tflag = false(obj.nelem,1);
	for idx=1:length(pdx)
		% find the two adjoint elemetns
		tdx = find(any(obj.elem == pdx(idx),2));
		% do not process twice
		% TODO reiterate
		if (any(tflag(tdx)))
			continue;
		end
		if (2~=length(tdx))
			error('here');
		end
		tflag(tdx) = true;
		% get the other three vertices
		pdx_ = flat(obj.elem(tdx,:));
		pdx_ = unique(pdx_(pdx_ ~= pdx(idx)));
		if (3~=length(pdx_))
			error('here');
		end
		% update first triangle
		obj.elem(tdx(1),1:3) = pdx_;
		% mark point for removal
		dpdx = [dpdx; pdx(idx)];
		% mark second triangle for deletion
		dtdx = [dtdx; tdx(2)];		
	end
	% delete elements
	obj.elem(dtdx,:) = [];
	% delete points
	fprintf(1,'Removing %d triply connected boundary points\n',length(dpdx));
	obj.remove_points(dpdx);
	% lazy edge restoral
	obj.edges_from_elements();
end

