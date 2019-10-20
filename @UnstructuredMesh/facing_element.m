% Sun 20 Nov 11:39:19 CET 2016
% Karl Kastner, Berlin
%
%% get triangle ndx that is opposit, e.g. "facing" the vertex vdx of triangle tdx
%
% input:
%	tdx : indices of triangles whos neighbours are determined
%	vdx : index of vertex opposit the neighbour
% output
%	ndx : indices of triangles neighbouring tdx and facing vdx
%	      zero, if no triangle faces this vertex
function [ndx, obj] = facing_element(obj,tdx,vdx)
	% get element neighbours
	t2t = obj.elem2elem(tdx,:);

	% for triangles, these are arranged, such that the neighbour opposit a
	% vertex has the same index as the vertex
	t   = obj.elem(tdx,:);
	ndx = sum((t == vdx).*t2t,2);
end

