% 2016-02-14 19:30:01.203868525 +0100
% Karl Kastner, Berlin
% 
% remove degenerated triangles with zero area
%
function mesh = remove_empty_triangles(mesh)
	a   = mesh.element_area();
	fdx = (abs(a) > 0);
	mesh.elem = mesh.elem(fdx,:);
	mesh.edges_from_elements();
	n   = length(fdx) - sum(fdx);
	fprintf(1,'Removed %d empty triangles\n',n);
end

