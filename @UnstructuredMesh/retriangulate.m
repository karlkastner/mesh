% Mon  5 Dec 09:35:47 CET 2016
% Karl Kastner, Berlin
%% retriangulate the mesh
function obj = retriangulate(obj)
	% delaunay triangulation
	DT = delaunayTriangulation(obj.point(:,1:2), ...
			           obj.edge(obj.bnd,:));
	% elements (triangles)
	T  = DT.ConnectivityList;
	% remove triangles outside the domain
	in = isInterior(DT);
	T = T(in,:);
	% TODO, check points outside of the domain,
	% for those triangles, split them at the projected point
	obj.elem  = T;
	obj.point = DT.Points;
	obj.remove_isolated_vertices();
	obj.edges_from_elements();
end

