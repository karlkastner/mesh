% Thu 16 Jun 14:20:48 CEST 2016
% Karl Kastner, Berlin
%% refine by splitting marked triangles
function [mesh, obj] = refine(obj,fdx)
	% if no selection is made, select all elements for refinement
	if (nargin() < 2)
		fdx = (1:obj.nelem)';
	end
	elem  = int32(obj.elem);
	point = obj.point(:,1:2);
	bc    = int32(obj.edge(obj.bnd,:));
	if (isempty(bc))
		error('Boundary must not be empty');
	end
	% TODO make this part of Tree_2d
	if (size(elem,2) ~= 3)
		error('Number of points per element have to be 3 (only triangles allowed)');
	end
	%tree_2d = Tree_2d(point, elem, bc);
	tree_2d = javaObject('Tree_2d',point,elem,bc);
	tree_2d.refine(fdx);
	mesh_2d_java  = Mesh_2d_java(tree_2d.generate_mesh(true));
	mesh   = mesh_2d_java.MMesh;
	mesh.edges_from_elements();
end

