% Wed 26 Oct 12:24:05 CEST 2016
function f = length_var(x,y)
	[l] = Geometry.tri_edge_length(x,y);
%	f = (min(cosa)-max(cosa)).^2;
	f = var(l,[],2);
end

