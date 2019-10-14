% 2016-09-26 12:11:31.757306019 +0200

% circumferencescaling is not good, as diverges for obtuse elements
function [f g g_] = objective_angle_scaled_area(X,Y)
	a = Geometry.tri_area(X,Y);
	if (any(a<0))
		f   = NaN;
		g.x = NaN;
		g.y = NaN;
		return;
	end

	cosa = Geometry.tri_angle(X,Y);
	cosa = cosa(:,1);

	[void1 void2 Rc] = Geometry.circumferencecircle([ax bx cx],[ay by cy]);

	f = Rc^2.*(cosa - cosa0).^2
end

