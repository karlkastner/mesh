% Thu 24 Nov 14:00:56 CET 2016
% Karl Kastner, Berlin
function [vp obj] = interpolate_from_boundary(obj,vb)
	bnd1 = obj.bnd1;
	% first derivative matrices
	[Dx Dy] = obj.derivative_matrix();
	% Laplacian operator (sum of second derivative)
	D = Dx*Dx + Dy*Dy;
	% identity matrix for values at the boundary
	I = sparse((1:nb)',bnd1,ones(nb,1),nb,np);
	A = [D; I];
	% rhs: 0 second derivative at inner points, values at the boundary points
	%d(bnd1) = log(V(bnd1));
	b   = [zeros(nelem,1); V(bnd1)];
	%b   = [zeros(nelem,1); log(V(bnd1))];
	vp  = minres(A,b);
	%if (logflag)
	%	vp = exp(vp);	
	%end
end % interpolate_from_boundary

