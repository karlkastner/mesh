function [nelem obj] = add_element(obj,elem_new)
	nelem = obj.nelem+1;
	obj.elem(nelem,1:length(elem_new)) = elem_new;
end

