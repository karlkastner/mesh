% Fri 19 Jan 11:30:14 CET 2018
function [val, obj] = predict(obj,fieldname,varargin)
	val = []; % zeros(n,m,length(t));
	for jdx=1:obj.n2-1
	 for idx=1:obj.n1-1
		val(idx,jdx,:) = feval(obj.predfun,squeeze(obj.val.(fieldname)(idx,jdx,:)),varargin{:});
	 end % for idx
	end %for jdx
end % predict

