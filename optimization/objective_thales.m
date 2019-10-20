% 2016-09-23 20:07:37.860190343 +0200

function [f g g_] = objective_thales(xy,p)
	x = xy(1,:);
	y = xy(2,:);
	xl = left(x);
	xr = right(x);
	yl = left(y);
	yr = right(y);

	% sq length of opposit edge
	a2 = (xl-xr).^2+(yl-yr).^2;

	% centre of opposit edge
	xc = 0.5*(xl+xr);
	yc = 0.5*(yl+yr);

	% sq distance to opposit edge
	d2 = (xc-x).^2 + (yc-y).^2;

	% subtract to distinguish obtuse from acute triangles

	% normalise
	d2 = sqrt(d2./a2);

	% sum
	d2 = norm(d2,p);
	if (2 == p)
		d2=d2*d2;
	end
	f = d2;
end 


