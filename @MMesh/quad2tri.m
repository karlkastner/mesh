% Fri 27 May 16:41:43 CEST 2016
% Karl Kastner, Berlin
function obj = quad2tree(obj)
	[elem4 fdx] = obj.elemN(4);
	% TODO preallocate
	% TODO split along shorter segment
	for idx=1:length(fdx)
		ac  = obj.elem(fdx(idx),[1 3]);
		bd  = obj.elem(fdx(idx),[2 4]);
		lac = hypot(diff(obj.X(ac)),diff(obj.Y(ac)));
		lbd = hypot(diff(obj.X(bd)),diff(obj.Y(bd)));
		% split along shorter diagonal
		% TODO this does not guarantee that the resulting triangles are acute
		if (lac < lbd)
			obj.elem(fdx(idx),1:4) = [ac,bd(1),0];
			% TODO use add element function
			obj.elem(obj.nelem+1,1:4) = [ac,bd(2),0];
		else
			obj.elem(fdx(idx),1:4) = [bd,ac(1),0];
			% TODO use add element function
			obj.elem(obj.nelem+1,1:4) = [bd,ac(2),0];
		end
%		obj.elem(fdx(idx),4)      = 0;
%		obj.elem(obj.nelem+1,1:3) = elem4(idx,2:4);
	end % for idx
	% remove fourth dimension
	% if there are no higher order polygons
	if (4 == size(obj.elem,2))
		obj.elem(:,4) = [];
	end
	obj.edges_from_elements();
end % quad2tree()

