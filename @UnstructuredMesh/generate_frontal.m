% 2015-11-11 10:02:59.500202729 +0100
% Karl Kastner, Berlin

%- test cases : dumbell, crescent, n-gons: tri, rect, penta, hexa, ..., L-shape, hole, unequal edge size, stretched n-gon
%function frontal(obj)
%	-> input boundary length should not be too different
%	while there are more than three open boundaries (problematic if there are two holes (disjoint)
%	- take top boundary edge
%	- consider neighbour
%	- if angle to neighbour > 90
%		- add new point
%			- if other point is within range, do not add point but snap
%				- other point within the triangle
%				- distance to other point < 2*base_length
%			-> better place point at integer fraction with respect to opposing wall
%		- add new element from base to point
%		- remove old bnd edge
%		- add two new bnd edges
%	else if angle to neighbour < 90
%		add element by connecting to neighbouring point
%		- remove two bnd edges
%		- add one new bnd edge
%end
%
