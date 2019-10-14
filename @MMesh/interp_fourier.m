% Di 26. Jan 20:01:44 CET 2016
% Karl Kastner, Berlin
%
% interpolate values on the mesh using fourier methods
%
% TODO better to iteratively weigh residuals, such that the distribution becomes normal
function [f res V c Ai cdx tdx iter obj] = interp_fourier(obj,x0,y0,f0,W0,tdx,m,abstol,verbose)
	iterative  = true;
	% this is a quasi 1d-problem, so solver has to stop one time along the river
	MaxIter    = 1000;
	M_MAX      = 1000;
	nsplit = 2;
	M_MAX      = min(M_MAX,obj.np-1);
	stepfactor = 2.^0.25;
	cmse_old   = Inf;
	sdres_old = inf;
	condi_old = inf;
	f_old     = 0;
	df_old    = Inf;
	iter       = struct();

	if (nargin < 8)
		tdx = [];
	end

	if (nargin() < 9)
		verbose = false;
	end

	idx = 0;
	while (true)
	idx = idx+1;

	m = min(m,M_MAX);

	% get cosines
	[V E]   = obj.eigs(m,'neumann',verbose);
	lambda = 0; %1e-6*abs(E(1));
	% get sines
	[Vim Eim] = obj.eigs(m-1,'dirichlet',verbose);
	% combine
	V(:,2:end) = V(:,2:end) + 1i*Vim;

	% assemble the interpolation matrix of the operator
	timer    = tic();
	[Ai cdx tdx] = obj.interpolation_matrix(x0,y0);
	if (verbose)
		printf('Interpolation matrix setup %fs\n',toc(timer));
	end

	if (nargin() < 6 || isempty(W0))
		W0 = ones(size(Ai,2),1);
	%speye(length(f0));
	%elseif(isvector(W0))
	%	W0 = diag(sparse(W0));
	end	

	% determine the Fourier coefficients
	% TODO it should be checked, that the nnormal matrix is suitably conditioned,
	% however, matlab condest is too slow, so recycle the tridiagonal matrix of minres to run qr (or condest on the tridiagonal matrix)

	timer = tic();
	Ai_   = Ai(cdx,:);
	f0_   = f0(cdx);
	% interpolate weights and eigenfunctions to sample locations
	wi   = Ai_*W0;
	% TODO, rename into V0
	Vi   = Ai_*V;
	if (iterative)
		% interpolate the weight to the samples
		if (1)
			c = itersolve(Vi,f0_,wi,lambda);
			cmse = 0;
		else
		% for error estimation a split is done
		N  = (1:length(f0_))';
		%false(size(f0_));
		%fdx(1:2:end) = true;
		N = mod(N,nsplit)+1;
		cs = [];
		for jdx=1:nsplit
			fdx = (jdx == N);
			cs(:,jdx) = itersolve(Vi(fdx,:),f0_(fdx),wi(fdx),lambda);
			%cs(:,jdx) = robsolve(Vi(fdx,:),f0_(fdx),wi(fdx));
		end
		%c2 = itersolve(Vi(~fdx,:),f0_(~fdx),wi(~fdx),lambda);
		c    = mean(cs,2); %0.5*(c1+c2);
		%cmse = mean(abs(flat(bsxfun(@minus,cs,c))).^2); %(c1-c2);
		df = V*(cs(:,2)-cs(:,1));
		cmse = mse(df);
		end
	else
		% solve system by qr factorisation
		c = qrsolve(Vi,f0i,wi);
	end
	if (Debug.LEVEL > Inf)
		figure();
		clf
		d = diag(W0i);
		scatter3(x0(cdx),y0(cdx),d,[],d,'filled');
		view(0,90)
		colorbar
		pause
	end

	% interpolate by expanding the weighted eigenfunction series
	f  = real(V*c);
	df = f-f_old;

	% determine the residual
	res      = NaN(size(f0));
	res(cdx) = Ai_*f - f0_;

	condi = condest(Vi'*Vi);

	% scale the residual by dof
	n   = length(cdx);
	% the number of parameter is 2*nc+1, as they have a real and imaginary component
	np  = 2*length(c)+1;
	dof = n-np;
	res = (n/dof)*res;

	% robust estimate of the residual error, median has to be zero
	sdres = 1/norminv(0.75)*nanmedian(abs(res)); %mad(res,1);

	% store iteration information
	iter.sdres(idx) = sdres;
	iter.cmse(idx)  = cmse;
	iter.cond(idx)  = condi;

	% stop if desired accuracy is achieved
	% maximum number of basis vectors exceeded
	% or error stagnates
	if (sdres <= abstol || m >= M_MAX ...
	    ... || condi*sdres >= condi_old*sdres_old; 
            ... || cmse >= cmse_old ...
	    || median(abs(df)) > median(abs(df_old)) ...
	    || sdres >= sdres_old ...
            || ~isfinite(sdres) || ~isfinite(cmse))
		% TODO restore optimum if cmse did not improve
		break;
	end
	m         = ceil(stepfactor*m);
	sdres_old = sdres;
	cmse_old  = cmse;
	condi_old  = condi;
	f_old = f;
	df_old = df;
	end % while true

	if (verbose)
		printf('Interpolation coefficient determination %fs\n',toc(timer));
	end
%
% sub-functions
%

% TODO apply regularisation
function c = qrsolve(A,f,w,lambda)
	% apply fourier window, making the function periodic
	% note, the windowing is not a weighted least squares problem
	mu = wmean(w,f);
	wf = w.*f + (1.0-w)*mu;

	% solve least squares system by QR factorisation	
	[Q R] = qr(A,0);
	c = Q'*(R \ (Q*(Q'*wf)));
	%c = (Vi'*Vi) \ (Vi'*W0i*f0(cdx));
end

function c = robsolve(A,f,w)
	mu = wmean(w,f);
	wf = w.*f + (1.0-w)*mu;
	c = robustfit(A,wf,[],[],'off');
end

function c = itersolve(A,f,w,lambda)
	% Minres requires square matrix, so pass normal matrix A'A
	%I = speye(size(A,2));
	afun = @(x) A'*(A*x) + lambda*x;
	%V'*(Ai_'*(Ai_*(V*b)));
	mu = wmean(w,f);
	b  = A'*(w.*f + (1.0-w)*mu);
	c  = minres(afun, b, [], MaxIter);
end

end % interp_fourier

