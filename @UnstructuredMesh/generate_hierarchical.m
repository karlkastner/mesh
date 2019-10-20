% Sa 14. Nov 18:21:00 CET 2015
% Karl Kastner, Berlin
%
%% generate a hierachical mesh by recursively splitting elements
%% containing boundary points
%
% TODO move to Tree_2d_java
function obj = tree_generate(obj, xb, yb, rb, resfun, boundary_closure,h)
	if (nargin < 6)
		boundary_closure = 'void';
	end

	% enclose domain in hexagon / triangle
	% start with an initial mesh (bounding equilateral triangle)
	fdx = isfinite(xb);
	[X Y elem a] = Geometry.enclosing_triangle(xb(fdx),yb(fdx));

	% create Tree_2d object
	obj.point = [X Y];
	obj.elem  = elem;
	obj.edges_from_elements();

	Bc        = obj.edge(obj.bnd,:);
	tree_2d   = Tree_2d([X Y],elem,Bc);

	l = hypot(X(1)-X(2),Y(1)-Y(2));
	n = 2;
while (l/n > rb)
	% TODO all elements containing a boundary point
	% determine all elements intersected by the boundary
	%printf('interation %d\n',idx)

	% for each boundary point
	% mark each triangle that is separated by a boundary line
	a = [flat(xb(fdx)), flat(yb(fdx))];
	M = tree_2d.isin2(a);
	fdx = M>0;
	M = M(fdx);
	if (isempty(M))
		break;
	end

	% mark all elements intersected by the boundary and where local edge length does not exceed rb for splitting
	% refine by splitting marked triangles
	tree_2d.fill_R();
	tree_2d.refine(M);
	n = 2*n;

if (0)
	mesh_2d       = tree_2d.generate_mesh(true);
	mesh_2d_java  = Mesh_2d_java(mesh_2d);
	mesh          = mesh_2d_java.MMesh;
	mesh.plot();
	tree_2d.get_data()
	pause
end
end % while (l/n > h)
	
	mesh_2d       = tree_2d.generate_mesh(true);
	mesh_2d_java  = Mesh_2d_java(mesh_2d);
	mesh          = mesh_2d_java.MMesh;
	obj.point     = mesh.point;
	obj.elem      = mesh.elem;

% local refinement up to desired local resolution
%while (change)
	%for all triangles
		%determine local max_edge_length from function at triangle centre
		%determine current max_edge_length
		%mark of current max_edge_length > local_max_edge_length
	%refine marked triangles
	%resolve green triangles
%end % while change

%	boundary_closure = 'void';

	% TODO there seems till to be a small bug, does not exactly yield the same result as inpoly
	% determine points inside the domain
	in = Geometry.inpolygon(xb,yb,obj.point(:,1),obj.point(:,2));
	%in = inpolygon(point(:,1),point(:,2),xb,yb);

	% TODO improve mesh quality by flipping, 4-removal and laplacian smoothing

	% remove points outside the domain
	obj.remove_points(~in);

	switch (boundary_closure)
	case {'void'}
	case {'chew'}
		error('not yet implemented');
	case {'3split'}
		% determine containing triangle for each boundary point and split in 3
		% TODO fast intesectt by including closed triangles to the triangle tree
		split_3()
		% add boundary point coordinates to the mesh
		np         = mesh.np;
		mesh.point = [mesh.point; bpoint];
		% update boundary edge index
		bE         = bE + np;
		% recover boundary edges
		mesh.recover_edges(bE);
		% TODO remove outside points and elements
		% TODO for numerical staibilty it is more useful to determine removal by mid-points
	case {'move'}
		% for each point on the mesh boundary,
		% move that point to the closest point on the physical boundary
		% TODO closest boundary element and than segment it
		obj.edges_from_elements();
		obj.scale_to_boundary(xp,yp);	
	case {'delaunay'}
		% if (strmcp(boundary_closure,'delaunay')
		% constrained delaunay
		x      = obj.point(:,1);
		y      = obj.point(:,2);
		hold on
		plot(x,y,'r.')
pause
		%[id D] = knnsearch([cvec(shp.X),cvec(shp.Y)],[cvec(x),cvec(y)]);
		[id D] = knnsearch([xb,yb],[cvec(x),cvec(y)]);
		fdx    = D >= h;

		
		[xb,yb,E] = edge_from_bnd(xb,yb);
		x = [cvec(xb);x(fdx)];
		y = [cvec(yb);y(fdx)];
		P = [x y];
		DT = delaunayTriangulation(P,E);
		T = DT.ConnectivityList;
		% remove triangles outside the domain
		in = isInterior(DT);
		T = T(in,:);
		
		obj.elem = T;
		obj.point = DT.Points;
		max(E)
		size(P)
		max(T)

		% there can now be lone points, remove them
		%obj.remove_points(fdx);
	case {'scale'}
		x      = obj.point(:,1);
		y      = obj.point(:,2);
		%[id D] = knnsearch([cvec(shp.X),cvec(shp.Y)],[cvec(x),cvec(y)]);
		[id D] = knnsearch([xb,yb],[cvec(x),cvec(y)]);
		fdx    = D < h;
		% there can now be lone points, remove them
		obj.remove_points(fdx);
	otherwise
		error('not yet implemented');
	end
		


end % function tree_generate

