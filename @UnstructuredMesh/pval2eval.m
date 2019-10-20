% Fri 16 Jun 10:50:27 CEST 2017
%% vertex to element value
function [vale,obj] = pval2eval(obj,valp)
	if (isvector(valp))
		valp = cvec(valp);
	end
	vale = zeros(obj.nelem,1); %size(valp,2));
	for idx=2:size(obj.elem,2)
		[elem fdx] = obj.elemN(idx);
		if (~isempty(elem))
			vale(fdx,1) = mean(valp(elem),2);
		end
	end
end
