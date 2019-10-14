% 2016-01-26 19:12:39.252307965 +0100
% Karl Kastner, Berlin

%mesh coarsening
%	find triangle not having a node on the bnd and that was not created by the current coarsening iteration
%	(concave boundary segments can be savely joined)
%	-> replace three points by their arithmetic average
%	-> remove all neighbouring triangles (their number is arbitrary)
%		and save the open edge
%	-> for each open edge of the hole
%	-> connect the open edge to the new centre point to form a new triangle
%
%local coarsening
%	- edge removal
%	- triangle removal (equal to successive removal of three eges)
%	- remesh-local region
%
