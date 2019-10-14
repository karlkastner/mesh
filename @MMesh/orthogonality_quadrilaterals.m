% Wed 18 Jul 18:33:32 CEST 2018

function [acosa,alpha] = orthogonality_quadrilaterals(obj)
	% edges and edge points
	edge = obj.edge;
	e1 = obj.point(edge(:,1),1:2);
	e2 = obj.point(edge(:,2),1:2);

	% centroids of elements
	e2e = obj.edge2elem();
	c   = obj.element_centroid();

	% not for edges with only one neighbour
	fdx = all(e2e,2);

	% get centroid/circumcentre of left and right element
	c1    = c(e2e(fdx,1),:);
	c2    = c(e2e(fdx,2),:);
	acosa = NaN(obj.nedge,1);
	acosa(fdx) = Geometry.enclosed_angle((e1(fdx,:)-e2(fdx,:))',(c1-c2)');

	% dual edge
	% angle (inner product) with this mesh
end

