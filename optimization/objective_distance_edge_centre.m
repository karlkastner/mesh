% 2016-09-26 15:35:48.316662515 +0200
%
% vertex distance to optimum location with respect to opposit side
%
function f = objective_distance_edge_centre(X,Y)
	d2 = Geometry.tri_distance_opposit_midpoint(X,Y);
	% sq radius around opposit midpoint
	r2 = 0.25*Geometry.tri_side_length(X,Y);
	% objective function value per triangle
	f = 3*r2 - d2;
	f = f(1);

end

