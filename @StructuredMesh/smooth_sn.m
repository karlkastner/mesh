% Wed 28 Nov 14:20:46 CET 2018
function smooth_sn(obj,opt)
	if (nargin()<2)
		opt = struct;
	end
	if (~isfield(opt,'relax'))
		p = 0.5;
	else
		p = opt.relax;
	end
	if (~isfield(opt,'maxiter'))
		opt.maxiter = 10;
	end
	%obj.X = obj.X+sqrt(eps)*randn(obj.n);
	%obj.Y = obj.Y+sqrt(eps)*randn(obj.n);

	for idx=1:opt.maxiter
		n = obj.n;
		[S,N]  = obj.S();
		%S = S+sqrt(eps)*randn(obj.n);
		%N = N+sqrt(eps)*randn(obj.n);
		X = obj.X;
		Y = obj.Y;
		X1=X;
		X2=X;
		Y1=Y;
		Y2=Y;
		% along S
		Si = 0.5*(S(1:end-2,:) + S(3:end,:));
		for idx=1:n(2)
			fdx = isfinite(S(:,idx));
			fdx(2:end) = fdx(2:end) & S(2:end,idx) ~= S(1:end-1,idx);
			if (sum(fdx)>1)
			X1(2:end-1,idx) = interp1(S(fdx,idx),X(fdx,idx),Si(:,idx),'spline',NaN);
			Y1(2:end-1,idx) = interp1(S(fdx,idx),Y(fdx,idx),Si(:,idx),'spline',NaN);
			end
		end  
		fdx = ~isfinite(X1); X1(fdx) = X(fdx);
		fdx = ~isfinite(Y1); Y1(fdx) = Y(fdx);

		% along n
		Ni = 0.5*(N(:,1:end-2) + N(:,3:end));
		for idx=1:n(1)
			fdx = isfinite(N(idx,:));
			fdx(2:end) = fdx(2:end) & N(idx,2:end) ~= N(idx,1:end-1);
			if (sum(fdx)>1)
			X2(idx,2:end-1) = interp1(N(idx,fdx),X(idx,fdx),Ni(idx,:),'spline',NaN);
			Y2(idx,2:end-1) = interp1(N(idx,fdx),Y(idx,fdx),Ni(idx,:),'spline',NaN);
			end
		end  
		fdx = ~isfinite(X2); X2(fdx) = X(fdx);
		fdx = ~isfinite(Y2); Y2(fdx) = Y(fdx);

		X = (1-p)*X + p*0.5*(X1 + X2);
		Y = (1-p)*Y + p*0.5*(Y1 + Y2);
		obj.S_ = [];
		obj.N_ = [];
		obj.X = X;
		obj.Y = Y;

%		clf
%		obj.plot
%		axis equal
%		pause(1)
	end

end

