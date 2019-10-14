% Sun  4 Dec 15:37:17 CET 2016
% Karl Kastner, Berlin
%
% extract the 1d mesh
% 
function [mesh_2d obj] = mesh_2d(obj)
	% 1d elements
	[elem2 edx]  = obj.elemN(2);
	% non 1d elements
	fdx = ~edx;
	% copy
	mesh_2d = obj.copy;
	% remove 1d points and elements
	% (remove points also removes elements)
	mesh_2d.remove_points(unique(elem2(:)));
	mesh_2d.edges_from_elements();
end % mesh_1d

