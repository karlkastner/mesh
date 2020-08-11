% Wed 28 Feb 17:09:14 CET 2018
%% convert to unstructured mesh
function [umesh, obj] = to_UnstructuredMesh(obj)
	X = obj.X;
	Y = obj.Y;
	Z = obj.Z;
	elem = obj.elem;
	
	umesh       = UnstructuredMesh();
	umesh.point = [flat(X),flat(Y),flat(Z)];
	umesh.elem  = elem;

	fdx = isnan(umesh.X);
	umesh.remove_points(fdx);
	umesh.edges_from_elements();	
	umesh.boundary_condition_s = obj.boundary_condition_s;
%	umesh.remove_isolated_vertices();
end

