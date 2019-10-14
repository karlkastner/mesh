% Thu 11 Jan 09:33:09 CET 2018
% Karl Kastner, Berlin
%
% first order first derivative discretisation matrix on the mesh
%
% TODO works only for tetras
function [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz, obj] = derivative_matrix_3d_2(obj)
	% each tetra has 4 corners and 6 edges
	% determine values at edge midpoints
	% set up matrix determining edge-mid point values for the lagrangian
	% tetrahedron of quardatic order

	-> problem:
		each edge has more than two neighbours
		-> system is overdetermined
		-> determine in an average sense

end % derivative_matrix_3d

