% 2016-09-30 03:21:26.146117894 +0800
%% insert mid points into the mesh
%% the new mesh is of much lower quality, but if all edges are flipped,
%% this leads to the sqrt(2) refinement
function obj = insert_mid_points(obj,tdx)
	if (islogical(tdx))
		tdx = find(tdx);
	end
	printf('Inserting %d mid points\n',length(tdx));

	%
	% interior triangles
	%

	% get old obj boundary in point index form
	bnd = obj.edge(obj.bnd,:);

	% get old obj points
	X = obj.point(:,1);
	Y = obj.point(:,2);

	P = [X,Y];
	if (length(tdx) > 0)
	if (length(tdx) == 1)
		x_ = rvec(X(obj.elem(tdx,:)));
		y_ = rvec(Y(obj.elem(tdx,:)));

		% get centre of tri_excircle of requested elements
		[Xc Yc] = Geometry.tri_centroid(x_,y_);
	else
		X = obj.X;
		Y = obj.Y;
		[Xc Yc] = Geometry.tri_centroid(X(obj.elem(tdx,:)),Y(obj.elem(tdx,:)));
	end
	
	% add these points to the point mesh
	P = [P; Xc,Yc];
	end

	% reobj
	% TODO efficient implementation, remeshing of the complete mesh not necessary
	DT = delaunayTriangulation(P,bnd);
	T  = DT.ConnectivityList;
	% remove triangles outside the domain
	in = isInterior(DT);
	T = T(in,:);

	% TODO, check points outside of the domain,
	% for those triangles, split them at the projected point

	obj.elem  = T;
	obj.point = DT.Points;
	obj.remove_isolated_points();
	obj.edges_from_elements();
end
