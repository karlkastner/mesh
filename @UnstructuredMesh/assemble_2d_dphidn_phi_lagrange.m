% Thu 14 May 12:17:25 +08 2020
% int_Gamma dphi_dn phi d gamma
function A  = assemble_dphidn_phi_lagrange(obj,fun,fdx)
	% number of test functions per triangle
	nt2 = 3;

	% degree of basis function poynomial
	% cubic for hermite
	nv = 1;
	
	if (nargin()>3)
		bnd = obj.bnd(fdx);
	else
		bnd = obj.bnd;
	end

	% vertex indices of boundary elements
	tdx = obj.edge2elem(bnd,1);
	T   = obj.elem(tdx,:);

	% element corner coordinates
	X  = reshape(obj.X(T(:,1:3)),[],3); 
	Y  = reshape(obj.Y(T(:,1:3)),[],3);

	% boundary coordinates
	Xb = reshape(obj.X(obj.edge(bnd,:)),[],2);
	Yb = reshape(obj.Y(obj.edge(bnd,:)),[],2);

	% boundary directions
	t   = obj.edge_direction(bnd,true);
	% correct sign of tangent

	% baricentric coordinates and weights for numerical quadrature
	[w, b] = feval(obj.int1);

	% number of buffer entries per triangle
	%mb0 = nt2*(nt2+1)/2;
	mb0 = nt2*nt2;

	% exact number of elements in buffer after integration
	nb0 = length(bnd)*mb0;

	% preallocate buffer
	buf = zeros(nb0,3);
%	buf_ = zeros(nb0,3);
%	nb_ = 0;
	% integrate along each boundary edge
	nb = 0;
	for tdx=1:length(bnd)
		% corner vertices
		xp = X(tdx,:).';
		yp = Y(tdx,:).';
		% boundary vertices
		xb = Xb(tdx,:).';
		yb = Yb(tdx,:).';

		% translate, for better conditioning
		% TODO, scale and rotate
		% and simplify with christoffel symbols
		xb = xb - xp(1);
		yb = yb - yp(1);
		xp = xp - xp(1);
		yp = yp - yp(1);

		% homogeneous edge coordinates
		% x_ = [0,l_(jdx)]';
		%A  = vander_1d(x_,1);
		Ax = vander_1d(xb,1);
		Ay = vander_1d(yb,1);

		% edge length
		length_ = hypot(diff(xb),diff(yb));

		% homogeneous cartesian coordinates of quadrature points
		qx = b*Ax;
		qy = b*Ay;

		% vandermonde matrix at corners
		% structure: [1 x y xy x^2 y^2]
		% A*c = rhs
		Va  = [   vander_2d(xp,yp,nv); ];

		% test/basis function evaulation weights (cubic)
		% rows: test functions, columns: weights
		% C(i,:) * A(:,i) = 1; C(i,:) * A(:,j) = 0, i<>j
		% note : this is already close to singular without rescaling
		C = inv(Va);

		% evaluate test function derivative at the quadrature points
		% test function derivative evaluated at the points
		% rows: function, columns: points
		Vq      = vander_2d(qx(:,2), qy(:,2), nv);
		% value at quadrature points
		phi     = Vq*C;

		% function value at boundaries
		% deriative along cartesian axes
		Vqd     = vander_2d(qx(:,2), qy(:,2), nv-1);
		[dC_dx, dC_dy] = derivative_2d(C, nv);

		% derivative normal to boundary at quatrature points
		dC_dn   = t(tdx,2)*dC_dx - t(tdx,1)*dC_dy;
		% derivative at quadrature points
		dphi_dn = Vqd*dC_dn;

		% evaluate the coefficient function at the integration points
		% and premultiply values
		if (nargin() > 2 && ~isempty(func))
			wfa = length_*w.*feval(func,[qx(:,2),qy(:,2)]);
		else
			wfa = length_*w;
		end

		% integrate dphi*phi along boundary
		% note : order is important, it is phi*dphi_dn, not dphi_dn*phi!
		[buf,nb] = append2buffer_asym(buf,nb,T(tdx,:),wfa,phi,dphi_dn);
%		[buf,nb] = append2buffer_asym(buf,nb,T(tdx,:),wfa,dphi_dn,phi);
	end % for tdx (each boundary triangle)

	if (nb ~= nb0)
		warning('preallocation insufficient');
	end

	% construct matrix from buffer
	dof = obj.np;
	A   = sparse(buf(:,1), buf(:,2), buf(:,3), dof, dof); 
end % function assemble_2d_dphidn_phi_hermite

