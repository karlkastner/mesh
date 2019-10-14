% Sun  4 Dec 15:37:17 CET 2016
% Karl Kastner, Berlin
%
% extract the 1d mesh
% 
% TODO take over width
function [mesh_1d obj] = mesh_1d(obj)
	% coordinates
	elem2  = obj.elemN(2);
	% vertex indices
	[pdx i1 i2] = unique(elem2);
	% vertex coordinate
	point2 = obj.point(pdx,:);
	%point2 = obj.point();
	% update point coordinates
	elem2 = i2;
%	elem2 = reshape(i2,[],2);
	% 1d mesh
	mesh_1d = MMesh(point2,elem2);
	mesh_1d.edges_from_elements();
end % mesh_1d

