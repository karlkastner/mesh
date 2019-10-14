% Tue Apr 19 15:51:36 CEST 2016
% Karl Kastner, Berlin
%
% interpolation wiht Tikhonov regularisation
%
function [fi, res, cflag, mse, mse_fi] = interp_tikhonov_2d(obj, ...
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
		[Dx, Dy] = obj.derivative_matrix_2d();
	else
		% streamwise: (dz/ds = 0)
		[Ds, Dn] = obj.streamwise_derivative_matrix();
		Dx=Ds;
		Dy=Dn;
	end

	% actually a difference matrix is required, but this is difficult to define in a triangulation,
	% assume rectangular domain and scale with domain length
	if (0)
		Lx = range(obj.X);
		Ly = range(obj.Y);
		Dx = Lx*Dx;
		Dy = Ly*Dy;
	end
	
	% find elements containing samples
	[tdx, cflag, nn] = obj.assign_2d(P0);
	cflag = cflag & isfinite(f0);
	ns = sum(cflag);

	if (0 == ns)
		error('number of points in domain is zero');
	end

	% set up interpolation matrix for samples
	[A, cflag_] = obj.interpolation_matrix_2d(P0(cflag,:),tdx(cflag));
		
	% weigth is inverse number of points per element	
	% weigh to make regularisation scale invariant
	% TODO here one may deactivate regularisation in rows of D for points having nonzero contribution in rows of A
	if (isscalar(w) && w)
		ww  = 1./nn;

		% distribute weights to points
		n        = sum(cflag);
		w        = zeros(n,1);
		w(cflag) = ww(tdx(cflag));
	end

	if (isempty(w))
		% no weighting
		W = 1;
	else
			W = diag(sparse(w(cflag)));
	end

	% regularise by the approx sqrt of the number of samples
	L   = diag(sparse(sqrt(nn+1)));
	Lhs = (A'*W*A ...
		+ lambda(1)*(Dx'*L*Dx) ...
		+ lambda(2)*(Dy'*L*Dy));
	rhs = (A'*W*double(f0(cflag)));

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
	res(cflag) = A*fi - f0(cflag);
	%res = double(res);

	% parameter error
	%np = length(fi);
	%mse = (res'*W*res)/(ns-np);
	% it is not possible to determine the effective dof without determining the
	% singular values, 
	%dof = ns - np;
	dof = ns;
	mse = (res(cflag)'*W*res(cflag))/dof;
	

	if (nargout()>4)
		mse_fi = mse*diag(inv(Lhs));
	end
end % interp_thikonov_2d

