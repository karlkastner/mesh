% Wed 26 Oct 12:24:14 CEST 2016
function f = objective_length_min_max(x,y)
	[l] = Geometry.tri_edge_length(x,y);
%	f = (min(cosa)-max(cosa)).^2;
%	f = var(l,[],2);
	f = (max(l)-min(l)).^2;
end

