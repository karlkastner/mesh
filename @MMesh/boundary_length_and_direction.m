% Mon May  2 10:16:55 CEST 2016
% Karl Kastner
% TODO, this should be just edge length and direction
function [l dir obj] = boundary_length_and_direction(obj,idx)
	% boundary mid points
	bnd = obj.edge(obj.bnd,:);
	X   = reshape(obj.X(bnd),[],2);
	Y   = reshape(obj.Y(bnd),[],2);
	dX  = diff(X,[],2);
	dY  = diff(Y,[],2);
	l   = hypot(dX,dY);
	if (nargout() > 1)
		dir = [dX./l, dY./l];
		if (nargin() > 1)
			l   = l(idx);
			dir = dir(idx,:);
		end
	else
		l   = l(idx);
	end
end

