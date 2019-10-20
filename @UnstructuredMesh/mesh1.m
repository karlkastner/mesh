% Di 15. Dez 17:26:06 CET 2015
% Karl Kastner, Berlin
%
%% mesh in 1D
%
function [X, Y, E] = mesh1(obj,X,Y,h)
	dx = diff(cvec(X));
	dy = diff(cvec(Y));
	% cdiff ?
	S  = [0;  cumsum(hypot(dx,dy))];
	n  = round(S(end)/h);
	if (n > 2)
	hi = S(end)/n;
	Si = hi*(0:n-1)';
	XY = interp1(S,[cvec(X) cvec(Y)],Si,'pchip');
	X  = XY(:,1);
	Y  = XY(:,2);
	E  = [(1:n)', [(2:n), 1]'];
	else
		X = [];
		Y = [];
		E = zeros(0,2);
	end
end

