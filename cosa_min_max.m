function f = cosa_min_max(x,y)
	[cosa] = Geometry.tri_angle(x,y);
	f = (min(cosa)-max(cosa)).^2;
end

