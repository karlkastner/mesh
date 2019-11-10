% Wed 30 Nov 19:26:03 CET 2016
% Karl Kastner,Berlin
%
% select 1D vertices in the mesh
% this does not return elements, as it is not unique
%
% TODO allow for selection of 2D and 3D vertices
function [pdx, obj] = vertices_1d(obj)
	elem2 = obj.elemN(2);
	if (~isempty(elem2))
		[u, n] = count_occurence(elem2(:));
		pdx = u(n>2);
	else
		pdx = [];
	end
end

