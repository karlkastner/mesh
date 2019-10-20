% Mon  5 Dec 09:40:17 CET 2016
% Karl Kastner, Berlin
%% split obtuse elements
function obj = split_obtuse(obj,fdx)
	o = double(fdx);
	N = zeros(size(fdx));
	if (islogical(fdx))
		fdx = find(fdx);
	end
	% TODO check if this is a triangle

	issplit = false(obj.nedge,1);
	% determine obtuse edge
	cosa    = obj.angle(fdx);
	% max angle is min cosa
	[mv mdx] = min(cosa,[],2);
	for idx=1:length(fdx)
		% determine opposit triangle
		ndx = obj.elem2elem(fdx(idx),mdx(idx));
		% if not on a boundary
		if (ndx > 0)
		N(ndx) = true;
			% local index the two non-common edges
			edx = (obj.elem2elem(ndx,:) ~= fdx(idx));
			% global edge index
			edx = obj.elem2edge(ndx,edx);
			% avoid dublicate splitting
			edx = edx(~issplit(edx));
			% edge to vertex index
			%pdx     = obj.edge(edx,:);
			% edge midpoints
			Pc = obj.edge_midpoint(edx);
			% add edge midpoints as new vertices
			obj.add_vertex(Pc(:,1),Pc(:,2));
			% mark edges as split
			issplit(edx) = true;
		end % if ndx > 0
	end % for idx
%	opt.edges = true;
%	figure
%	obj.plot(o+2*N,opt);
%axis equal
%pause
	
	% lazy retriangulation
	obj.retriangulate();
end % split_obtuse

