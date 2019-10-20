% Sa 28. Nov 11:48:45 CET 2015
% Karl Kastner, Berlin
%
%% remove points that are not part of the mesh
%% (gmsh leaves sometimes spurious points in the msh file)
%
% QUADSAVE_TRUE
function [ddx obj] = remove_isolated_vertices(obj)
	np = size(obj.point,1);
	id = false(np,1);
	for jdx=2:size(obj.elem,2);
		elemN = obj.elemN(jdx);
		if (~isempty(elemN))
		id(elemN(:)) = true;
%		for idx=1:jdx
%			id(elemN(:,idx)) = true;
%		end
		end
	end
	% find points not belonging to any element
	id = ~id;
	% remove these points
	ddx = obj.remove_points(id);
	obj.edges_from_elements();
	n = sum(id);
	fprintf(1,'Removed %d isolated points\n',n);
	if (nargout()<2)
		clear ddx
	end
end % remove_isolated_triangles

