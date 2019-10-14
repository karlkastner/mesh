% Thu 22 Jun 09:41:05 CEST 2017
% Karl Kastner, Berlin
%
% interpolation wiht Tikhonov regularisation
%
function [fi res cflag mse mse_fi] = interp_tikhonov_1d(obj,x0,f0,lambda,w,bc)

	if (nargin() < 5)
		w = [];
	end

	if (nargin() < 6)
		bc = [];
	end


	% set up of Tikhonov matrix for all elements
	D = obj.derivative_matrix_1d();
	D = D.s;
	
	% find elements containing samples
	[tdx cflag nn] = obj.assign_1d(x0);
	cflag          = cflag & isfinite(f0);
	ns             = sum(cflag);

	% set up interpolation matrix for samples
	[A cflag_] = obj.interpolation_matrix_1d(x0(cflag),tdx(cflag));
		
	% weigth is inverse number of points per element
	% weigh to make regularisation scale invariant
	% TODO here one may deactivate regularisation in rows of D for points having nonzero contribution in rows of A (local lambda)
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
	L = diag(sparse(sqrt(nn+1)));
	Lhs = (  A'*W*A ...
	       + lambda*(D'*L*D));
	rhs = (A'*W*double(f0(cflag)));

	% apply dirichlet boundary conditions and forced points
	if (~isempty(bc))
		fdx        = knnsearch(obj.X,cvec(bc.X));
		Lhs(fdx,:) = 0;
		%AWA(fdx,:) = 0;
		%D(:,fdx)   = 0;
		ind        = sub2ind(size(Lhs),fdx,fdx);
		Lhs(ind)   = 1;
		%AWA(ind)  = 1;
		rhs(fdx)   = bc.val;
	end % if bc

	% TODO, use chol or CG/minres here
	fi  = Lhs \ rhs;

	% compute the residual
	res        = NaN(size(f0));
	res(cflag) = A*fi - f0(cflag);
	%res = double(res);

	% parameter error
	np = length(fi);
	mse = (res(cflag)'*W*res(cflag))/(ns-np);
	mse_fi = mse*diag(inv(Lhs));
end % interp_thikonov_1d

