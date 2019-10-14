hexa mesh:
even
odd
top
bottom
left
right

tri2hexa:
- replace 6 triangles by hexas (this is not unique, start in corner)

-> one (n) hexagon mesh
-> split hexas containing edges
-> split hexas that where neighbours was split a second time
-> repeat until minimum edge length was reached

-> resample boundary so that distance between points is less than resolution
recursive refinement
for each boundary point:
	find containing element
		split it (recursively)
		-> what if it ends up in corner point
-

split:
	insert the six new points of the central child
	insert this element
	for each of the sith corners
		if all three adjacent triangles have been split
			(or less if on boundary, in this case new points have to be inserted)
			insert corner element (points have already been created)
		end
	end

closure
todo boundary
- if no neighbour split with finer level
	-> add this element to final mesh
-> if any neighbour is finer, triangle
	for each of the six triangles
	if neighbour has not child (is not of lower level)
	- insert triangle a,b,center
	- insert two triangles: center,a,end point of neighbour child
				center,b,end point of neighbour child
-> if any neighbour is coarser, insert two brige element is it has not jet been done
	(boundary treatment: split boundary hexas into triangle, remove triangle whos centre is not in domain)


