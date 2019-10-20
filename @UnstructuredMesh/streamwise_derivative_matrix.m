% 2016-08-02 19:45:51.300086028 +0200
%% streamwise derivative matrix
function [Ds, Dn, Dx, Dy, xc, yc, d1, d2] = streamwise_derivative_matrix(obj)
	[xc yc] = obj.element_midpoint();

	% get streamwise direction
	id         = obj.nearest_boundary(xc,yc);
	[void dir] = obj.boundary_length_and_direction(id);

	% get unprojected derivative
	[Dx Dy] = obj.derivative_matrix();

	% project to streamwise (S) direction
	d1 = diag(sparse(dir(:,1)));
	d2 = diag(sparse(dir(:,2)));
	Ds = d1*Dx + d2*Dy;
%	bsxfun makes the matrix full and is dead slow
%	Ds = bsxfun(@times,Dx,dir(:,1)) + bsxfun(@times,Dy,dir(:,2));
	
	% project to spanwise direction
	Dn = d2*Dx - d1*Dy;
	% orthogonal direction
%	Dn = bsxfun(@times,Dx,dir(:,2)) - bsxfun(@times,Dy,dir(:,1));

end

