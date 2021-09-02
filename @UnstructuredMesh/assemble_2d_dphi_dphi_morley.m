% Wed 13 May 14:53:10 +08 2020
% morley element : values in corners and normal derivatives at edge centres
function A = assemble_dphidphi_morley(mesh)
	T  = mesh.elem;
	X  = mesh.X(T); 
	Y  = mesh.X(T); 
	Xe = mesh.edge_midpoint();
	Ye = mesh.edge_midpoint();
	Xe = Xe(mesh.elem2edge);
	Ye = Ye(mesh.elem2edge);
	Te = mesh.edge_direction();
	% edge normal direction
	Ne = [-Te(:,2),Te(:,1)];
	Nx = Ne(mesh.elem2edge,1);
	Ny = Ne(mesh.elem2edge,2);
%	Xe = 0.5*(  mesh.X(mesh.edge(mesh.elem2edge,1));
%                  + mesh.X(mesh.edge(mesh.elem2edge,2)));
%	Ye = 0.5*(  mesh.X(mesh.edge(mesh.elem2edge,1));
%                  + mesh.X(mesh.edge(mesh.elem2edge,2)));

	% integration rule coefficients
	% TODO
	[w,b] = feval(int);

	% preallocate buffer
	buf = zeros(mesh.nelem,6);

	nb = 0;

	% for each element
	for tdx=1:mesh.nelem
		% corner vertices
		xp = X(tdx,:);
		yp = Y(tdx,:);

		% edge mit-points
		xe = Xe(tdx,:);
		ye = Ye(tdx,:);

		% translate, for better conditioning
		% TODO, scale and rotate
		xe = xe - xp(1);
		ye = ye - yp(1);
		xp = xp - xp(1);
		yp = yp - yp(1);

		% xy-coordinates of integration points
		A   = vander2d(xp,yp,1);
		xyi = A*b;

		% normal edge directions
		nx = Nx(tdx,:);
		ny = Ny(tdx,:);
		      
		% test function coefficients (quadratic)
		% A*c = rhs
		A  = [    vander_2d(xp,yp,2);
                       (  vanderdx_2d(xe,ye,2)*diag(nx) ...
		        + vanderdy_2d(xe,ye,2)*diag(ny) ) 
                     ];
		C  = inv(A);

		% derivatives
		[dC_x, dC_y] = derivative_2d(C, 1);
%		Dx = [0,1,0,0,0,0;
%                      0,0,0,2,0,0;
%                      0,0,0,0,1,0];
%		Dy = [0,0,1,0,0,0;
%                      0,0,0,0,1,0;
%                      0,0,0,0,0,2];

		% evaluation matrix of derivative at integration points
		Ai  = vander_2d(xi,yi,1);
		dphi_dx = Ai*dC_x;
		dphi_dy = Ai*dC_y;

		% mass matrix contributions
		% for all test functions being 1 at point adx
%		nb = mb0*(tdx-1);
		for adx=1:nt2
			% diagonal entry integral approximation
			% factor 0.5 for later symmetry completion
			I         = 0.5*sum( w.*(dphi_x(:,adx).^2 + dphi_y(:,adx).^2) );
			nb        = nb+1;
			buf(nb,1) = T(tdx,adx);
			buf(nb,2) = T(tdx,adx);
			% separate, as otherwise silent conversion to int 
			buf(nb,3) = I;
			% off diagonal entries
			% exploit symmetry A(i,j) = A(j,i)
			for bdx=(adx+1):nt2
				% integral approximation
				I = sum( w.*(  dphi_x(:,adx).*dphi_x(:,bdx) ...
					     + dphi_y(:,adx).*dphi_y(:,bdx)) );
				nb = nb+1;
				buf(nb,1) = T(tdx,adx);
				buf(nb,2) = T(tdx,bdx);
				% separate, as otherwise silent conversion to int 
				buf(nb,3) = I; 
			end % for jdx
		end % for adx
	end % for tdx (each triangle)

	% construct matrix from buffer
	dof = mesh.np+mesh.nedge;
	A   = sparse(buf(:,1), buf(:,2), buf(:,3), dof, dof); 

	% complete symmetry
	A = A + A';
end % function assemble_dphi_dphi_morley

