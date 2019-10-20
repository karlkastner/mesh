% Fri 15 Dec 11:16:09 CET 2017
function [x] = mesh1(Xi,nx,xs)
	L = Xi(2)-Xi(1);

	% growth of mesh size
%	a  = log(xs)/(nx-1);
	a  = (xs).^(1/(nx-2));
	dx = a.^(0:nx-2).';
	x  = cumsum([0;dx]);
	% scale and shift
	x = Xi(1)+x*L/x(end);

	% dx1/dxn = xs
	% scale by 1/2 not necessary, as scaled by sum(end)
%	id   = (0:nx).';
%	sumi = id.*(id+1);
%	X = X(1) + sumi*(L/sumi(end));
end

