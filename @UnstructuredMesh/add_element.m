% 2016-12-09 18:47:37.753455783 +0800
%% add an element with vertex indices, vertices already exist
function [nelem obj] = add_element(obj,elem_new)
	nelem = obj.nelem+1;
	obj.elem(nelem,1:length(elem_new)) = elem_new;
end

