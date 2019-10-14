% 2016-05-26 15:37:35.353690509 +0200 /home/pia/phd/src/lib/@MMesh/coarsen2.m

%- simple coarsen
%- remove every other point, exept boundary points
%- remesh
%
%- for all boundary points
%- mark as keep (1)
%- push all their neighbours into the open list
%
%while open
%	if not yet processed (0)
%	mark as removed (2)
%	for all neigbours
%	mark as keep (1)
%	
%- take first boundary point
%- take neighbour that is not on the boundary
%
