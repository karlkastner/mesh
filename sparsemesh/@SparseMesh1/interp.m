% Mon 28 May 18:28:47 CEST 2018
% Karl Kästner, Berlin
%% interpolate data stored in field "field" to coordinates Xi
%% ingnore invalid data
%% TODO, check if convex
function vi = interp(obj,field,Xi)
	% allocate memory
	%vi      = NaN(size(Xi));
	x = obj.T.x(obj.T.sdx);
	v = obj.val.(field)(obj.T.sdx);
	% interpolate
	% ignore missing
	fdx = isfinite(v);
	vi  = interp1(x(fdx),v(fdx),Xi,'linear',NaN);
end % interp


