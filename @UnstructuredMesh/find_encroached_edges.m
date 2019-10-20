% Wed 26 Oct 09:55:24 CEST 2016
% Karl Kastner, Berlin
%
%% find encroached edges in a triangulation,
%% i.e. edges for which on of the two facing point false into their enclosing
%% circle
% TODO only for triangles
function [edgedx, obj] = find_encroached_edges(obj)
	X = obj.elemX;
	Y = obj.elemY;
	% midpoints
	Xc = 0.5*(left(X)+right(X));
	Yc = 0.5*(left(Y)+right(Y));
	% radii
	dX = (left(X)-right(X));
	dY = (left(Y)-right(Y));
	r  = 0.5*hypot(dX,dY);
	% distance opposit midpoint
	d  = hypot(X-Xc,Y-Yc);
	% encroached edges
	ise = (d<r);
	edgedx = obj.elem2edge(ise);
	edgedx = unique(edgedx(:));
	% find encroached edge
%	[xc yc l] = Geometry.tri_edge_midpoint(obj.elemX,obj.elemY);
	% TODO this is a slow quick fix
%	[id dis]  = knnsearch(obj.X,obj.Y,cx,yc);
%	edx = find(dis < l,1);
end

