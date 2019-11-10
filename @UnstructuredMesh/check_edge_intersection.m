% Fri  8 Nov 15:44:54 +08 2019
function [flagi,s,t] = check_edge_intersection(obj);
	X = obj.X;
	Y = obj.Y;
	X = X(obj.edge);
	Y = Y(obj.edge);
	[flagi, s, t, p, q, den] = Geometry.lineintersect( ...
						X',Y', ...
						X',Y' );
end
