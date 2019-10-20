% Sun 25 Sep 16:01:52 CEST 2016

function d = objective_thales_difference(xy,p)
	x = xy(1,:);
	y = xy(2,:);
	xl = left(x);
	xr = right(x);
	yl = left(y);
	yr = right(y);
	% half side length of opposit edge
	a2 = 0.5*sqrt(((xl-xr).^2+(yl-yr).^2));

	% centre of opposit edge
	xc = 0.5*(xl+xr);
	yc = 0.5*(yl+yr);

	% distance to opposit edge
	d2 = sqrt( (xc-x).^2 + (yc-y).^2);

	% subtract to distinguish obtuse from acute triangles
	% for the equilateral triangle this is sqrt(3)/2
	s = 1; %sqrt(3)/2;
%	d = s*a2 - d2;
%	d = s*a2.*a2 - d2.*d2;
	s = sqrt(3);
	d = max(0,s*a2 - d2);

	if (~strcmp('inf',p))
		%d = sum(d);
		d = norm(d,p).^p;
	else
		%d = max(d);
		d = norm(d,p);
	end
%	if (strcmp('inf',p))
%		d = max(d);
%	else
%		%d = sum(sign(d).*abs(d).^p);
%		%d = sign(d).*abs(d).^(1/p);
%	end

	% normalise
	%d2 = sqrt(d2./a2);
	% sum
	%d2 = norm(d2,p);
	%if (2 == p)
	%	d2=d2*d2;
	%end
end 

