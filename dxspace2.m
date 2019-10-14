% Thu  9 May 10:35:44 CEST 2019
% L : length (should be x0, x1
% ratio = dx(end)/dx(1)
function [x, dx] = dxspace2(L,ratio,n)
	% L_ = sum r^i/n

	dx=ratio.^((0:n)/n);
	%dn(2:end)./dn(1:end-1);
	x     = [0,cumsum(dx)];
	scale = L/x(end);
	x     = scale*x;
	if (nargout() > 1)
		%dx = diff(x);
		dx = scale*dx;
	end
end

