% Di 3. Nov 12:15:17 CET 2015
% Karl Kastner, Berlin
%
% nonobtuse refinement according to Korotov
% not feasible for most obtuse triangles
%
function [idx mesh] = nonobtuse_refinement(mesh,abstol,idx)
	% final refinement
	elem  = mesh.elem(:,1:3);
	point = mesh.point(:,1:2);
	bc    = mesh.edge(mesh.bnd,:);
	tree_2d = Tree_2d(point(:,1:2), elem(:,1:3), bc);
	cosa_   = tree_2d.angle(); 
	northo_ = tree_2d.is_obtuse(abstol);
%	[sum(northo) sum(northo_) sum(abs(northo-northo_))]
	tree_2d.refine_nonobtuse(abstol);
	mesh_2d_java  = Mesh_2d_java(tree_2d.generate_mesh(true));
	mesh          = mesh_2d_java.MMesh;

	c=mesh.check_orthogonality();
	no = sum(~c);
	ne = length(c);
	fprintf('number of elements %d\n',ne);
	fprintf('number of obtuse triangles %d\n',no);
	fprintf('fraction of obtuse triangles %f\n',no/ne);

	idx=idx+1;
	figure(idx)
	cosa = min(mesh.angle,[],2);
	ortho = cosa > -sqrt(eps);
	%[ortho Xc Yc R obj] = mesh.check_orthogonality();
	elem = mesh.elem;
	X = mesh.point(:,1);
	Y = mesh.point(:,2);
	%trisurf(elem,X,Y,[],double(~ortho));
	trisurf(elem,X,Y,[],cosa);
	view(0,90)
	axis equal
	caxis([-0.2 0.0])
	colorbar hot
end

