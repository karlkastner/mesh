% Tue May  1 01:19:46 MSK 2012
% Karl Kästner, Berlin
%
% integrates product of the derivatives of the Lagrangian test functions
%
% T : points on the triangle point, first three points are corners (size = [1 .. 6])
function [A, buf] = assemble_2d_dphi_dphi_lagrange(mesh, func);
	T = mesh.elem;
	%P = mesh.point;
	X  = reshape(mesh.X(T),[],3); 
	Y  = reshape(mesh.Y(T),[],3);
	% for the rare case of just 1 element, reconvert column to row vector
	if (1 == mesh.nelem)
		X = rvec(X);
		Y = rvec(Y);
	end

	nt1 = size(T,1);
	nt2 = size(T,2);

	% degree of basis function polynomial (always an integer)
	% 1,2,3, 4, 5, 6
	% 1,3,6,10,15,21 
	%nv = -1.5 + sqrt(2*nt2 + 0.25);
	nv = (-3 + sqrt(8*nt2 + 1))/2;

	% baricentric coordinates and weights for numerica quadrature
	[w, b] = feval(mesh.int2);

	% number of buffer entries per triangle
	mb0 = nt2*(nt2+1)/2;


	% preallocate buffer
	% exact number of elements in buffer after integration
	nb0 = nt1*mb0;

	buf = zeros(nb0,3);

	% integrate over each triangle
	nb = 0;
	for tdx=1:mesh.nelem
		% corner vertices
		%xp = P(T(tdx,:),1).';
		%yp = P(T(tdx,:),2).';
		xp = X(tdx,:).';
		yp = Y(tdx,:).';

		% translate, for better conditioning
		% TODO, scale and rotate
		% and simplify with christoffel symbols
		xp = xp - xp(1);
		yp = yp - yp(1);

		% homogeneous corner point coordinates
		A = vander_2d(xp, yp, 1);
		%A = [   1, P(T(tdx,1),:);
                %        1, P(T(tdx,2),:);
                %        1, P(T(tdx,3),:) ]; 

		% triangle area
		area = 0.5*abs(det(A));

		% homogeneous cartesian coordinates for quadrature
		q = b*A;

		% vandermonde matrix at mesh points
		% structure: [1 x y xy x^2 y^2]
		%Va = vander_2d(P(T(tdx,:),:), nv);
		Va = vander_2d(xp,yp, nv);
		%Va = vander_2d(P(T(tdx,:),1),P(T(idx,:),2), nv);

		% test function evaulation weights (cubic)
		% rows: test functions, columns: weights
		% C(i,:) * A(:,i) = 1; C(i,:) * A(:,j) = 0, i<>j
		C = inv(Va);
	
		% evaluation weights of first derivative of the test functions
		% at quadrature points
		% structure: dphi([1 x y]') : [dc00 dc01 dc10]*[1 x y]'
		[dC_dx, dC_dy] = derivative_2d(C, nv);
	
		% evaluate test function derivative at the quadrature points
		% test function derivative evaluated at the points
		% rows: function, columns: points
		Vq = vander_2d(q(:,2), q(:,3), nv-1);
		dphi_dx = Vq*dC_dx;
		dphi_dy = Vq*dC_dy;

		% evaluate the coefficient function at the integration points
		% and premultiply values
		if (nargin() > 2 && ~isempty(func))
			wfa = -area*w.*feval(func,q(:,2:3));
		else
			wfa = -area*w;
		end

		% mass matrix contributions
		[buf,nb] = append2buffer_dphi_dphi(buf,nb,T(tdx,:),wfa,dphi_dx,dphi_dy);
%		% for all test functions being 1 at point adx
%		for adx=1:nt2
%			% diagonal entry integral approximation
%			% factor 0.5 for later symmetry completion
%			I = 0.5*sum( wfa.*(  dphi_dx(:,adx).^2 ...
%                                           + dphi_dy(:,adx).^2) );
%			nb = nb+1;
%			buf(nb,1) = T(tdx,adx);
%			buf(nb,2) = T(tdx,adx);
%			% separate, as otherwise silent conversion to int 
%			buf(nb,3) = I;
%			% off-diagonal entries
%			% exploit symmetry A(i,j) = A(j,i)
%			for bdx=(adx+1):nt2
%				% integral approximation
%				I = sum( wfa.*(   dphi_dx(:,adx).*dphi_dx(:,bdx) ...
%						+ dphi_dy(:,adx).*dphi_dy(:,bdx)) );
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
%	nb
%	nb0
%	mesh.nelem
%	size(T)
%	size(C)
%pause
	% construct matrix from buffer
	dof = mesh.np;
	A = sparse(buf(:,1), buf(:,2), buf(:,3), dof, dof);

	% complete symmetry
	A = A + A';

%'lagrange'
%	A_   = sparse(buf_(:,1), buf_(:,2), buf_(:,3), dof, dof); 
%	norm(full(A_-A))
%pause
end % function assemble_2d_dphi_dphi_lagrange

