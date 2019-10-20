% 2016-02-16 16:56:40.356158154 +0100
% 
%% make all 2D elements clock wise (such that their area is positive)
%
function obj = make_elements_cw(obj)
	area = obj.element_area();
	fdx  = area < 0;
	% for triangles only two poinst have to be swapped, for polygons the directions has to change
	% swap
	if (0)
		p1             = obj.elem(fdx,1);
		obj.elem(fdx,1) = obj.elem(fdx,2);
		obj.elem(fdx,2) = p1;
	else
		for idx=3:size(obj.elem,2)
			[elemN ndx] = obj.elemN(idx);
			if (~isempty(ndx))
				fdx = area(ndx) < 0;
				obj.elem(ndx(fdx),1:idx) = fliplr(elemN(fdx,:));
			end
		end
	end
	
	obj.edges_from_elements();
%	obj.elem(obj.elem,fdx,1);
end

