% Sun 20 Nov 13:35:23 CET 2016
% Karl Kastner, Berlin
%% connectivity matrix between vertices and adjacent edges
% TODO, this can be combined with vertex_to_vertex and setting the
%       the values of the matrix to the edge number
function [v2edge ] = vertex_2_edge(obj)
	% vertex indices of edges
	vdx   = obj.edge;
	%
	nedge = size(vdx,1);
	% edge indices
	edx = repmat((1:nedge)',1,2);
	% connectivity matrix
	v2edge = sparse(flat(vdx),flat(edx),flat(edx),obj.np,nedge);	
	%v2edge = sparse(flat(vdx),flat(edx),ones(2*nedge,1),obj.np,nedge);	
end 

