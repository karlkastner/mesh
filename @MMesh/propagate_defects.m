% Fri 10 Mar 14:13:31 CET 2017
% TODO combine with circumcentre/encroached edge insertion
function propagate_defects(obj)

	smooth / optimise
	-> find vertices at obtuse angles
	(TODO start with vertex furthest away from the boundary)
	-> find facing edge closest to the boundary
	-> TODO if several are equally far, take longest
	-> (TODO threshold necessary to only split it if edge is not too small???)
	-> if this edge is not a boundary
		split

	
	while ()
		% while there are 4-connected interior vertices
		% (related to encroached edges)
		fdx = []
		% 
		if (~isempty(open))
			% find edge nearest to the boundary
			% if not on boundary, split
			% TODO flip? if edges are flipped, defects can propagate inwards
			if ()
				% add new point to open list
				
			end
		end
		% smooth
		TODO

		% if there is at least one more obtuse triangles
		while ()
			% insert centre of circumference
			% flip edges to restore delaunay trinagulation
			% (TODO point can be located beyond the facing triangle in special cases)
		end
	end % while

	% while there are obtuse trianles where the obtuse angle is not
	% facing a boundary
	while (true)
		% smooth
		% TODO better reltol
		obj.smooth();

		% find obtuse angles
		isobtuse = obj.angle() < 0
		% obj.obtuse_triangles();

		% determine edges
		isbnd  = false(obj.nedge,1);
		isbnd(obj.bnd) = true;
		edge = obj.elem2edge();
		isbnd = bnd(edge);

		% determine edges opposit obtuse angles that are not a boundary
		edge = edge(isobtuse & (~isbnd));

		% stop if there are no interior obtuse triangles
		if (edge(fdx))
			disp('No remaining iterior obtuse triangles');
			break;
		end

		% (if circumcentre inside domain -> this is not strict if there are holes)
		% (insert circumcentre)

		% recusively split edges until the boundary is reached
		while (true)
			% split edge and get index of the new point
			pdx = obj.split_edge(fdx);

			% (flip edges (not necessary for split))
			% (if new vertex has connectivity 4 - always the case for edge split)
	
			% facing edges
			ndx = obj.facing_edges(pdx);
	
			% hop-distance of facing edges to the boundary
			D = obj.bnd_distance_edge(ndx)
	
			% TODO, take longest if there are two edges with the same distance
			[minD mdx] = min(D);
			if (0 == minD)	
				break;
				%pdx = obj.split_edge(ndx(mdx));
			else
			fdx = ndx(mdx);
		end % while true (split edges)
	end % while true (obtuse triangles)

	% TODO, split boundary edges
end % propagate_defects

