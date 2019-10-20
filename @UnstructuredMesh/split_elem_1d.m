% Thu 31 Aug 11:50:27 CEST 2017
%% split a 1d element
% TODO rename into refine 1d
function [obj] = split_elem_1d(obj,edx)
	if (islogical(edx))
		edx = find(edx);
	else
		edx = unique(edx);
	end
	ne = length(edx);
	elem = obj.elem(edx,1:2);
	% TODO check if elements are indeed 1d

	% new midpoint
	XYc = obj.element_midpoint(edx);

	% add mid-points to mesh
	if (size(XYc,2)>2)
		pdx = obj.add_vertex(XYc(:,1),XYc(:,2),XYc(:,3));
	else
		pdx = obj.add_vertex(XYc(:,1),XYc(:,2));
	end

	% interpolate values
	field_C = fieldnames(obj.pval);
	for idx=1:length(field_C)
		field = field_C{idx};
		obj.pval.(field)(pdx) = mean(obj.pval.(field)(elem),2);		
	end

	e2 = elem(:,2);
	% crop old elements
	obj.elem(edx,2) = pdx;
	% add second half as new element
	obj.elem(end+1:end+ne,1:2) = [pdx,e2];
end

