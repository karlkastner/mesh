% Fri 21 Oct 16:46:47 CEST 2016
% Karl Kastner, Berlin
function [vi mesh] = interpolate_points(obj,x0,y0,v0)
	np = min(3,length(x0));
	if (np < 1)
		error('at least one point required');
	end
	
	X = obj.X;
	Y = obj.Y;
	% TODO, use mesh or at least hop distance here
	% get index and distance to three nearest neighbours of target point
	[id dis] = knnsearch([cvec(x0),cvec(y0)],[cvec(X),cvec(Y)]);
	% normalise the distance to obtain weights
	% this is nearly as good as linear interpolation with true baricentric coordinates,
	% but behaves better outside of the containing triangle (goes towards mean)
	% note, this is similar to idw with nearest neighbours (1-(n-1)*d/sum(d))
	% note that this is not preferable with more than 3 points: d = [1:10 1000]; w=1-(length(d)-1)*d/sum(d), sum(w)
	% maybe exponential is still better -> hoose e-folding length as distance to the closest point
	w = 1-2*bsxfun(@times,dis,1./dis);

	% interpolate
	vi = sum(v0(id).*w,2);
end % interpolate_point

