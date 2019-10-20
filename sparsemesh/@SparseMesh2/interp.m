% Sat 26 May 13:38:59 CEST 2018
% Karl Kästner, Berlin
%% interpolate data stored in field "field" to coordinates Xi
%% ingnore data outside of the domain (convex interpolation)
function vi = interp(obj,field,Xi)
	n = size(Xi,1);
	% allocate memeory
	vi   = NaN(n,1);
	% get index of containing triangle and barycentric coordinates
	% of point Xi with respect to the triangle
	[tid,B] = obj.T.pointLocation(obj.S(1)*Xi(:,1),obj.S(2)*Xi(:,2));
	% select interior points (points Xi that are inside the triangle)
	fdx = isfinite(tid);
	% vertex indices of triangle corners
	pid = obj.T.ConnectivityList(tid(fdx),:);
	% field values at triangle vertices
	vp = obj.val.(field)(pid);
	% interpolate with barycentric coordinates
	%vi(fdx) = B(fdx,:)*vp.';
	vi(fdx) = sum((B(fdx,:).*vp)').';
end % interp

