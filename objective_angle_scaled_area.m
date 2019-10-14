% 2016-09-26 12:11:31.757306019 +0200

% area scaling is not good, as area converges to zero for strongly obtuse elements
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

	A = Geometry.triarea(X,Y);
%	R = sqrt(A);

	f = A.*(acos(cosa(1)) - alpha0).^2
end

