% Sun  4 Dec 14:58:49 CET 2016
%% delete an element
function obj = delete_element(obj,ddx)
	obj.elem(ddx,:) = [];
end

