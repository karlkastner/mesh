% Wed 15 Jun 15:46:36 CEST 2016
%% remove trisected trianges
%% point has connectivity 3 and is not on the boundary
function obj = remove_trisected_triangles(obj)
	A   = obj.vertex_to_vertex();
	pdx = (3==sum(A));
	% exclude 1d elements
	elem2 = obj.elemN(2);
	if (~isempty(elem2))
		pdx(elem2(:)) = false;
	end
	% exclude vertices on the boundary
	bnd = obj.edge(obj.bnd,:);
	pdx(bnd(:)) = 0;
	pdx = find(pdx);
	dedx = [];
	for idx=1:length(pdx)
		% neighbours
		p = find(A(:,pdx(idx)));
		% find all elements containing that point
		pdx_ = find(any(obj.elem(:,1:3) == pdx(idx),2));
		% make the first triangle abc
		obj.elem(pdx_(1),1:3) = p;
		% mark other two elements for deletion
		dedx = [dedx;pdx_(2:3)];
	end % idx
	% delete the other two triangles
	obj.delete_element(dedx);
	% delete the points
	obj.remove_points(pdx);
end % remove_trisected_triangles

