% Fri  7 Dec 10:16:03 CET 2018
% function [x,dx] = dxspace(dx0,L,n)
function [x,dx] = dxspace(dx0,L,n,flag)
	% linear increase
	if (flag)
		a  = 2*(L-n*dx0)/(n*(n-1));
		dx = dx0+(0:n-1)*a;
	else
		% this variant is better conditioned for very coarse meshes and small dx:
		% can we do this from 0.5 or better 1/n?
		a  = 2*(L-n*dx0)/(n*(n+1));
		dx = dx0+(1:n)*a;
	end
	x = cumsum([0,dx]);
end

