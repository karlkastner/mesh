% Thu 11 Jan 09:08:45 CET 2018
% Karl Kastner, Berlin
%
% interpolation wiht Tikhonov regularisation in 3D
%
function [fi, res, cflag, nn, mse, mse_fi] = interp_tikhonov_3d(obj, ...
			    		     P0, f0, lambda, w, bc, streamwiseflag)

	if (nargin() < 5)
		w = [];
	end
	
	if (nargin() < 6)
		bc = [];
	end

	if (nargin()<7)
		streamwiseflag = false;
	end

	% set up of Tikhonov matrix for all elements

	if (~streamwiseflag)
		[Dx, Dy, Dz] = obj.derivative_matrix_3d();
	else
		% streamwise: (dz/ds = 0)
		% this is also 2D in xy for 3D meshes
		[Ds, Dn, Dz] = obj.streamwise_derivative_matrix();
		Dx=Ds;
		Dy=Dn;
	end

	% actually a difference matrix is required, but this is difficult to define in a triangulation,
	% assume rectangular domain and scale with domain length
	if (0)
		Lx = range(obj.X);
		Ly = range(obj.Y);
		Lz = range(obj.Z);
		Dx = Lx*Dx;
		Dy = Ly*Dy;
		Dz = Lz*Dz;
	end
	
	% find elements containing samples
	[tdx, cflag, nn] = obj.assign_3d(P0);
	cflag = cflag & all(isfinite(f0),2);
	ns = sum(cflag);

	if (0 == ns)
		error('number of points in domain is zero');
	end

	% set up interpolation matrix for samples
	[A, cflag_] = obj.interpolation_matrix_3d(P0(cflag,:),tdx(cflag));
		
	% weigth is inverse number of points per element	
	% weigh to make regularisation scale invariant
	% TODO here one may deactivate regularisation in rows of D for points having nonzero contribution in rows of A
	if (isscalar(w) && w)
		ww  = 1./nn;

		% distribute weights to points
		n   = sum(cflag);
		w   = zeros(n,1);
		w(cflag)   = ww(tdx(cflag));
	end

	if (isempty(w))
		% no weighting
		W = 1;
	else
		W = diag(sparse(w(cflag)));
	end
	AWA = A'*W*A;
	d   = diag(AWA);

	switch (0)
	case {0}
		Le = 1;
		Lp = 1;
	case {1}
		% regularise by the approx sqrt of the number of samples per element,
		% TODO this should be inverse proportional
		Le = diag(sparse(sqrt(nn+1)));
		Lp = 1;
	case {2}
		% regularise by the reciprocal number of samples per vertex
		% this is recommendet
		Lp = diag(sparse(sqrt(1./(d+1))));
		Le = 1;
	end

	Lhs = (AWA ...
		   + Lp*( lambda(1)*(Dx'*Le*Dx) ...
		   +      lambda(2)*(Dy'*Le*Dy) ...
		   +      lambda(3)*(Dz'*Le*Dz) ...
                        )*Lp ...
              );
	rhs = (A'*W*double(f0(cflag,:)));

	% apply dirichlet boundary conditions and forced points
	% TODO this only works for rectangular domains
	if (~isempty(bc))
		for idx=1:length(bc.Y)
			d2  = (obj.Y-bc.Y(idx)).^2;
			fdx = find(d2 <= bc.dmax^2);
			Lhs(fdx,:) = 0;
			%AWA(fdx,:) = 0;
			%Dx(fdx,:)  = 0;
			%Dy(fdx,:)  = 0;
			ind        = sub2ind(size(Lhs),fdx,fdx);
			Lhs(ind)   = 1;
			%AWA(fdx,:) = 1;
			rhs(fdx)   = bc.val(idx);
		end % for idx
	end % if bc

	% TODO, use CG/minres here
	fi   = Lhs \ rhs;

	% compute the residual
	res        = NaN(size(f0));
	res(cflag,:) = A*fi - f0(cflag,:);
	%res = double(res);

	% parameter error
	%np = length(fi);
	%mse = (res'*W*res)/(ns-np);
	% it is not possible to determine the effective dof without determining the
	% singular values, 
	%dof = ns - np;
	dof = ns;
	mse = (res(cflag,:)'*W*res(cflag,:))/dof;
	
	if (nargout()>5)
		mse_fi = mse*diag(inv(Lhs));
	end
end % interp_thikonov_2d

