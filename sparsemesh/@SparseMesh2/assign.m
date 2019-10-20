% Sat 26 May 13:38:59 CEST 2018
% Karl Kästner, Berlin
%% assign (lump) data "v0" sampled at sample times/location to field "field"
function obj = assign(obj,field,v0)
	v0 = v0(obj.fdx,:);
	if (length(v0) ~= obj.n0)
		error('length missmatch');
	end
	v0(end+1:obj.n*obj.m) = NaN;
	v0              = reshape(v0,obj.m,obj.n);
	obj.val.(field) = obj.mfun(v0);
	%obj.val.(field) = nanmedian(v0).';
end % assing


