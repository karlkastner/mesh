% Thu 27 Oct 15:14:09 CEST 2016
% Karl Kastner, Berlin
%
%% copy constructor
%
function [copy, obj] = copy(obj)
	copy = UnstructuredMesh();
        copy.point = obj.point;
        copy.elem = obj.elem;
        % edge indices
        copy.edge  = obj.edge;
	% element indices for each edge
	copy.edge2elem = obj.edge2elem;
	copy.elem2edge = obj.elem2edge;

	% boundaries, index into edge
	copy.bnd  = obj.bnd;

	field_C = fieldnames(obj.pval)
	for idx=1:length(field_C)
		copy.pval.(field_C{idx}) = obj.pval.(field_C{idx});
	end

%	?
%	cid;
%	?
%	weight;
	% adjacent segments, having at least one edge in common
%	sneighbour = [];
	% mesh points  common with neighbours
	% col1 : local index in this segment, col 2: local index in other segment
%	pinterface = {};
%	l2g = [];
end

