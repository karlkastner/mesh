% Mon 14 Nov 18:34:28 CET 2016
% Karl Kastner, Berlin
%
%% 2D elements from edges
function elem = elements_from_edges(x,y,edge,edge_type)

	% take over 1d elements (edges)
	fdx  = (   1 == edge_type ...
                 | 4 == edge_type );
	%elem = [];
	elem = edge(fdx,:);

	% remove 1d edges
	edge      = edge(~fdx,:);
	edge_type = edge_type(~fdx);

% TODO this does not yet fully work
% if two triangles form a rectangle, it may still detect two rectangles and a triangle,
% ditto for 4-5 and 4-6
	% n=6 allow up to hexgons
	nmax  = 4;
	nedge = size(edge,1);
	np    = max(edge(:));

	% connectivity matrix
	A = sparse([edge(:,1);edge(:,2)], [edge(:,2); edge(:,1)], ones(2*nedge,1), np, np);

	% for each point, traverse graph to find loops (elements)
	for idx=1:np
		elem = parse(idx,A,x,y,elem);
	end % for idx

function T = parse(chain,A,x,y,T)
	% avoid going back and forth and extending beyond one element
	if (any(chain(2:end-1) == chain(end)))
		return;
	end
	% avoid duplicate counting of elements, by making the first element
	if (chain(end) < chain(1))
		return;
	end
	% close chain, the are in between forms an element
	if (length(chain)>1 && chain(end) == chain(1))
		% do not store the same element twice in cw and ccw order
		if (Geometry.poly_area(x(chain),y(chain))>0)
			T(end+1,1:length(chain)-1) = chain(1:end-1);
		end
		return;
	end
	% stop if maximum number of vertices is reached
	if (length(chain) > nmax)
		return;
	end
	% get neighbours
	n = find(A(:,chain(end)));
	for idx=1:length(n)
		% extend chain
		T = parse([chain,n(idx)],A,x,y,T);
	end
end % parse

end % elements_from_edges

