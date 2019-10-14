% Wed 28 Feb 17:09:14 CET 2018
function [mmesh, obj] = to_MMesh(obj)
	X = obj.X;
	Y = obj.Y;
	Z = obj.Z;
	elem = obj.elem;
	
	mmesh       = MMesh();
	mmesh.point = [flat(X),flat(Y),flat(Z)];
	mmesh.elem  = elem;

	fdx = isnan(mmesh.X);
	mmesh.remove_points(fdx);
	mmesh.edges_from_elements();	
%	mmesh.remove_isolated_vertices();
end

