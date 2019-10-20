% Wed 28 Feb 17:09:14 CET 2018
%% convert to unstructured mesh
function [mmesh, obj] = to_UnstructuredMesh(obj)
	X = obj.X;
	Y = obj.Y;
	Z = obj.Z;
	elem = obj.elem;
	
	mmesh       = UnstructuredMesh();
	mmesh.point = [flat(X),flat(Y),flat(Z)];
	mmesh.elem  = elem;

	fdx = isnan(mmesh.X);
	mmesh.remove_points(fdx);
	mmesh.edges_from_elements();	
%	mmesh.remove_isolated_vertices();
end

