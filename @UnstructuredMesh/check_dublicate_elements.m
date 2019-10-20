% 2016-09-29 18:09:24.263969766 +0800
%% check if elements are duplicate elements
%% TODO, this does not check if elements cover each other, for example
%% hierarchical meshes or ABC+BCD and ABD+ACD
%% TODO check overlap by computation of area
function obj = check_dublicate_elements(obj)
	elem = obj.elem;
	[void, fdx] = unique(sort(elem,2),'rows');
	if (length(fdx) ~= obj.nelem)
		fdx_ = (1:obj.nelem)';
		fdx_(fdx) = [];
		error('here');
	end
end

