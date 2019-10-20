% Thu 22 Nov 14:45:44 CET 2018
%% return direction of boundary segment
function [dx,dy,bnd,iscorner] = boundary_direction(obj)
	order = 2;
%	order = 1;

	% boundary coordinates
	[bnd,iscorner] = obj.boundary_chain();
	X = obj.X;
	X = X(bnd);
	Y = obj.Y;
	Y = Y(bnd);

	switch (order)
	case {1}
		dx = X(:,3) - X(:,2);
		dy = Y(:,3) - Y(:,2);
	case {2}
		% vandermonde matrix
		A = vander_1d([0,-1,1]',2);
		c = A\X.';
		% derivative with respect to t
		dx = c(2,:).';
		c = A\Y.';
		% derivative with respect to t
		dy = c(2,:).';
	end

	% normalize
	l  = hypot(dx,dy);
	dx = dx./l;
	dy = dy./l;
	dx(~isfinite(dx)) = 0;
	dy(~isfinite(dy)) = 0;
end

