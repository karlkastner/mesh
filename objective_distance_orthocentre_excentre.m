function f = objective_distance_orthocentre_excentre(x,y,p)
	[xc yc] = Geometry.tri_excircle(x,y);
	[xi yi] = Geometry.orthocentre(x,y);
	d2 = sqrt((xc-xi).^2 + (yc-yi).^2);
	f = d2*d2;
end

