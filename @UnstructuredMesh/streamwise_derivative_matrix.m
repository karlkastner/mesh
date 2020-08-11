% 2016-08-02 19:45:51.300086028 +0200
%% streamwise derivative matrix
function [Ds, Dn, Dx, Dy, xc, yc, d1, d2] = streamwise_derivative_matrix(obj, u, v)
	[xc, yc] = obj.element_midpoint();

	if (nargin()<2)
		% trivial approach : flow direction parallel to nearest boundary
		id          = obj.nearest_boundary(xc,yc);
		[void, dir] = obj.boundary_length_and_direction(id);
	else
		% diriction from (potential) flow fied
		umag = hypot(u,v);
		dir  = [u,v]./umag;
	end

	% get unprojected derivative
	Dx = obj.Dx;
	Dy = obj.Dy;

	% project to streamwise (S) direction
	% note: bsxfun makes the matrix full and is dead slow
	d1 = diag(sparse(dir(:,1)));
	d2 = diag(sparse(dir(:,2)));
	Ds = d1*Dx + d2*Dy;
	
	% project to spanwise (N-ormal) direction (orthogonal direction)
	Dn = d2*Dx - d1*Dy;
end

