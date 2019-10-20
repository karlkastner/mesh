% Sat 26 May 13:38:59 CEST 2018
% Karl Kästner, Berlin
%% interpolate data stored in field "field" to coordinates Xi,
%% extrapolate beyond domain
function vi = interpS(obj,field,Xi)
	n = size(Xi,1);
	% allocate memeory
	vi    = NaN(length(obj.S0),n);
	% get triangle index and barycentric coordinates
	[tid,B] = obj.T.pointLocation(obj.S(1)*Xi(:,1),obj.S(2)*Xi(:,2));
	% select interior points
	fdx = isfinite(tid);
	% get vertex indices
	pid = obj.T.ConnectivityList(tid(fdx),:);

	% get values at vertices and interpolate
	vi(:,fdx) = ( bsxfun(@times,B(fdx,1).', obj.val.(field)(:,pid(:,1))) ...
	           + bsxfun(@times,B(fdx,2).', obj.val.(field)(:,pid(:,2))) ...
	           + bsxfun(@times,B(fdx,3).', obj.val.(field)(:,pid(:,3))) );
end % interpS

