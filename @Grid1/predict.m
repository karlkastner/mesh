% Fri 19 Jan 11:25:12 CET 2018
function [val, obj] = predict(obj,fieldname,varargin)
	val = []; %zeros(n,length(t));
	for idx=1:obj.n1-1
		val(idx,:,:) = obj.predfun(obj.val.(fieldname)(idx,:),varargin{:});
	end % for idx
end % predict

