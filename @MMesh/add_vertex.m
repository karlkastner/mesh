% Mon  5 Dec 09:39:31 CET 2016
function [pdx obj] = add_vertex(obj,X,Y,Z)
	np  = obj.np;
	np_ = np+length(X);

	field_C = fieldnames(obj.pval);
	for idx=1:length(field_C)
		obj.pval.(field_C{idx})(np+1:np_) = NaN;
	end

	pdx = (np+1:np_)';
	obj.point(pdx,1:2) = [cvec(X) cvec(Y)];
	if (nargin() > 3)
	obj.point(pdx,3) = cvec(Z);
	end
end

