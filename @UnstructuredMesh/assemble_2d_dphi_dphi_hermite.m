% Wed 13 May 15:31:48 +08 2020
% hermite element : values and first derivative in vertices
% function [A, buf] = assemble_dphi_dphi_hermite(obj)
function [A, buf] = assemble_2d_dphi_dphi_hermite(obj)
	% number of test functions per triangle
	nt2 = 10;

	% degree of basis function poynomial
	% cubic for hermite
	nv = 3;

	% vertex indices of elements
	T  = obj.elem;
	% indices of remaining degrees of freedom
	% x-derivative at corners
	T(:,4:6) = T(:,1:3) +   obj.np;
	% y-derivative at corners
	T(:,7:9) = T(:,1:3) + 2*obj.np;
	% value at element centroid
	T(:,10)  = (3*obj.np+1):(3*obj.np+obj.nelem);

	% element corner coordinates
	X  = reshape(obj.X(T(:,1:3)),[],3); 
	Y  = reshape(obj.Y(T(:,1:3)),[],3);

	% for the rare case of just 1 element, reconvert column to row vector
%	if (1 == obj.nelem)
%		X = rvec(X);
%		Y = rvec(Y);
%	end
	% triangle midpoint
	Xm = mean(X,2);
	Ym = mean(Y,2);

	% baricentric coordinates and weights for numerical quadrature
	[w, b] = feval(obj.int2);

	% number of buffer entries per triangle
	mb0 = nt2*(nt2+1)/2;

	% exact number of elements in buffer after integration
	nb0 = size(T,1)*mb0;

	% preallocate buffer
	buf = zeros(nb0,3);

	% integrate over each triangle
	nb = 0;
	for tdx=1:obj.nelem
		% corner vertices
		xp = X(tdx,:).';
		yp = Y(tdx,:).';
		xm = Xm(tdx);
		ym = Ym(tdx);

		% translate, for better conditioning
		% TODO, scale and rotate
		% and simplify with christoffel symbols
		xm = xm - xp(1);
		ym = ym - yp(1);
		xp = xp - xp(1);
		yp = yp - yp(1);

		% homogeneous corner point coordinates
		A    = vander_2d(xp, yp, 1);

		% triangle area
		area = 0.5*abs(det(A));

		% homogeneous cartesian coordinates for quadrature
		q = b*A;

		% vandermonde matrix at corners
		% structure: [1 x y xy x^2 y^2]
		% A*c = rhs
		[Dx,Dy] = vanderd_2d(xp,yp,nv);
		Va  = [   vander_2d(xp,yp,nv);
                          Dx;
		          Dy;
		          vander_2d(xm,ym,nv);
                     ];

		% test/basis function evaulation weights (cubic)
		% rows: test functions, columns: weights
		% C(i,:) * A(:,i) = 1; C(i,:) * A(:,j) = 0, i<>j
		% note : this is already close to singular without rescaling
		C  = inv(Va);

		% evaluate test function derivative at the quadrature points
		% test function derivative evaluated at the points
		% rows: function, columns: points
		Vq      = vander_2d(q(:,2), q(:,3), nv-1);

		% evaluation weights of first derivative of the test functions
		% at quadrature points
		% structure: dphi([1 x y]') : [dc00 dc01 dc10]*[1 x y]'
		[dC_dx, dC_dy] = derivative_2d(C, nv);

		% derivative at quadrature points
		dphi_dx = Vq*dC_dx;
		dphi_dy = Vq*dC_dy;
		% [dphi_dx, dphi_dy] = vanderd_2d(xyi(:,1),xyi(:,2),3)

		% evaluate the coefficient function at the integration points
		% and premultiply values
		if (nargin() > 2 && ~isempty(func))
			wfa = area*w.*feval(func,q(:,2:3));
		else
			wfa = area*w;
		end

		% integrate grad phi grad phi over element
		[buf,nb] = append2buffer_dphi_dphi(buf,nb,T(tdx,:),wfa,dphi_dx,dphi_dy);
%		% mass matrix contributions
%		% for all test functions being 1 at point adx
%		for adx=1:nt2
%			% diagonal entry integral approximation
%			% factor 0.5 for later symmetry completion
%			I         = 0.5*sum( wfa.*(dphi_dx(:,adx).^2 ...
%                                                 + dphi_dy(:,adx).^2) );
%			nb        = nb+1;
%			buf(nb,1) = T(tdx,adx);
%			buf(nb,2) = T(tdx,adx);
%			% separate, as otherwise silent conversion to int 
%			buf(nb,3) = I;
%			% off-diagonal entries
%			% exploit symmetry A(i,j) = A(j,i)
%			for bdx=(adx+1):nt2
%				% integral approximation
%				I = sum( wfa.*(  dphi_dx(:,adx).*dphi_dx(:,bdx) ...
%					     + dphi_dy(:,adx).*dphi_dy(:,bdx)) );
%				nb = nb+1;
%				buf(nb,1) = T(tdx,adx);
%				buf(nb,2) = T(tdx,bdx);
%				% separate, as otherwise silent conversion to int 
%				buf(nb,3) = I; 
%			end % for jdx
%		end % for adx

	end % for tdx (each triangle)

	if (nb ~= nb0)
		warning('preallocation insufficient');
	end

	% construct matrix from buffer
	dof = 3*obj.np+obj.nelem;
	A   = sparse(buf(:,1), buf(:,2), buf(:,3), dof, dof); 
	% complete symmetry
	A = A + A';

end % function assemble_2d_dphi_dphi_hermite

