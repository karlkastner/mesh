	-> objective function: square of inner product between edge and centroid-connector
	- get circumcentres / orthocentres
	(linf, l1, l2)
	for each edge:
		- get centroids / circumcentres of two adjacents elements
		- get angle of the connection line with edge
	gradient w/r to each point location
	bnd optimisation:
		- express angle between circumcentre and edge as function
		- get gradient w/r to dx, get gradient w/r to dy
	for boundary points:
		(- express bnd vertex as quandratic/hermite polynomial)
		- project gradient to direction of polynomial at point
	- step: 
	note: gradient has to be calculated for each point and each edge (!), as the centroid moves

	
	% edges are influenced by all vertices of the two facing elements,
	% not just the two of the edge itself, as the centroid moves
	for each edge
		for the two adjoining elements
			for each point in the elements
				get grad of objective function
			end
		end
	end
	for each bnd point
		% relax bnd constraint: partially project gradient: g_ = ((1-p)I + pP)g           
		project gradient
	end
	zero gradient of all blacklisted points

