% Wed 13 May 15:45:36 +08 2020
function [Dx,Dy] = derivative_matrix_2d_hermite(obj)
	dof = 3*obj.npoint + obj.nelem;
	d = zeros(dof,1);
	d(np+1:2*np) = 1;
	Dx = diag(sparse(d));
	d = zeros(dof,1);
	d(2*np+1:3*np) = 1;
	Dy = diag(sparse(d));
end

