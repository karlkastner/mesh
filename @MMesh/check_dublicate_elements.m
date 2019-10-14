function obj = check_dublicate_elements(obj)
	elem = obj.elem;
	[void fdx] = unique(sort(elem,2),'rows');
	if (length(fdx) ~= obj.nelem)
		fdx_ = (1:obj.nelem)';
		fdx_(fdx) = [];
		error('here');
	end
end

