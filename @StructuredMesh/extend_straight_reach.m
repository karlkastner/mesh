% Wed 23 Oct 09:59:09 +08 2019
% in delft3d,
% oscillations can emerge in bed level and propagate upstream from the downstream
% boundary the boundary is not straight, e.g. in a circular flume
% this can be avoided by appending a straight reach,
% this is because the surface across the channel is forced by the boundary
% condition to be level, while any curvature of the channel will require it to tilt
% TODO option for straightening
% TODO option to rotate matrix to append at any end
function obj = extend_sraight_reach(obj,l,k)
	if (nargin() < 2 || isempty(l))
		dx = diff(obj.X(end-1:end,:));
		dy = diff(obj.Y(end-1:end,:));
		l = mean(hypot(dx,dy));
	end
	if (nargin()<3 || isempty(k))
		k = 1;
	end

	X  = obj.X(end,:);
	dx = diff(obj.X(end,:));
	dy = diff(obj.Y(end,:));
	dx = [dx(1), mid(dx), dx(end)];
	dy = [dy(1), mid(dy), dy(end)];
	h = hypot(dx,dy);
	dx = dx./h;
	dy = dy./h;

	% prodrude in orthogonal direction
	obj.X(end+(1:k),:) = bsxfun(@plus, obj.X(end,:), (1:k)'*(-dy*l));
	obj.Y(end+(1:k),:) = bsxfun(@plus, obj.Y(end,:), (1:k)'*( dx*l));
	
	obj.extract_elements();
end % extend straight reach

