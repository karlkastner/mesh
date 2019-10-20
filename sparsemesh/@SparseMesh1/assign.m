% Mon 28 May 18:28:47 CEST 2018
% Karl Kästner, Berlin
%% assign (lump) data "v0" sampled at sample times/location to field "field"
%%
function obj = assign(obj,field,v0)
	if (length(v0) ~= obj.n0)
		error('length missmatch');
	end
	if (isempty(obj.dxmax))
		v0 = v0(obj.fdx);
		v0(end+1:obj.n*obj.m) = NaN;
		v0 = reshape(v0,obj.m,obj.n);
		v  = obj.mfun(v0);
	else
		v = accumarray(obj.id,v0,[obj.n+1,1],obj.mfun,NaN(class(v0)));
		
	end
	obj.val.(field) = v;
end % assign

