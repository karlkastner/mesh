% Mon 28 Aug 13:16:02 CEST 2017
%% convert a 1D mesh to 2D mesh consisting of quadrilaterals
% TODO: set up 1d mesh as hexagons, that are concave and follow
% the curvature of the channel
%
function from_1d_mesh(obj,eX,eY,W)
	% 1d element midpoints
	eXc = 0.5*(eX(1:end-1)+eX(2:end));
	eYc = 0.5*(eY(1:end-1)+eY(2:end));
	% length
	dX  = diff(eX);
	dY  = diff(eY);
	l   = hypot(dX,dY);
	% direction
	dX  = dX./l;
	dY  = dY./l;
	% left and right point (left and right is arbitrary)
	% in orthogonal direction of element
	X = [cX+0.5*W.*dY,cX-0.5*W.*dY];
	Y = [cY-0.5*W.*dX,cY+0.5*W.*dX];
	obj.X = X;
	obj.Y = Y;
	% TODO simplest case is to set up quads and to average the edge points of two neighbouring elements
	% cubically interpolate elem edge points to the right neighbour
	% only if there is one right neighbour
	% two cases, neighbour is oriented in the same direction or facind direction
	% x0, dx0, x1, dx1
end % from_1d_mesh

