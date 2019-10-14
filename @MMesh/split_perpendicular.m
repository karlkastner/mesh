% Fri  9 Dec 11:28:28 CET 2016
% Karl Kastner, Berlin
function obj = split_perpendicular(obj,fdx)
	if (islogical(fdx))
		fdx = find(fdx);
	end
	edge   = obj.edge(fdx,:);
	elemid = obj.edge2elem(fdx,:);
	elem   = obj.elem(elemid(:,1),:);
	for idx=1:length(fdx)
		if (elemid(idx,2)>0)
			fprintf('Not splitting edge %d, as it is not a boundary edge\n',fdx(idx));
		else
			% opposit point
			odx = elem(idx,  (elem(idx,:) ~= edge(idx,1)) ...
                                       & (elem(idx,:) ~= edge(idx,2)));
			% foot point coordinte	
			XYn = Geometry.base_point([obj.X(odx);obj.Y(odx)], ...
					[obj.X(edge(idx,1));obj.Y(edge(idx,1))], ...
					[obj.X(edge(idx,2));obj.Y(edge(idx,2))]);
			
			% add point
			obj.add_vertex(XYn(1),XYn(2));
			ndx = obj.np;

			% TODO push the edge slightly to the outside, to make the triangles acute
			

			% update first triangle
			obj.elem(elemid(idx,1),1:3) = [odx,edge(idx,1),ndx];
			% add new triangle
			obj.add_element([odx,edge(idx,2),ndx]);
		end % else of if
	end % idx
end % split_perpendicular

