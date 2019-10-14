% 2018-02-25 14:09:11.339322390 
function ds = smooth_curvilinear(obj,opt,fixed)
	if (nargin() < 2)
		opt = struct();
	end
	if (~isfield(opt,'maxiter'))
		opt.maxiter = 40;
	end
	if (~isfield(opt,'relax'))
		opt.relax = 0.05;
	end
	if (nargin()<3)
		fixed = [];
	end
	opt.s = true;
	opt.n = true;

	X = flat(obj.X);
	Y = flat(obj.Y);
	X0 = X(fixed);
	Y0 = Y(fixed);
	ds = zeros(opt.maxiter,1);
	for idx=1:opt.maxiter
		Xold = X;
		Yold = Y;
		[X,Y] = smooth(X,Y);
		ds(idx) = max(flat(hypot(X-Xold,Y-Yold)));
		if (idx > 1)
			% relax = min(0.5,relax*d(idx-1)/d(idx))
			%%relax = (10+relax)/11;
			%%relax = min(0.5,relax);
		end
		X = real(X);
		Y = real(Y);
%		X = reshape(X,obj.n);
%		Y = reshape(X,obj.n);
		X(fixed) = X0;
		Y(fixed) = Y0;
	end
	obj.X = reshape(X,obj.n);
	obj.Y = reshape(Y,obj.n);

function [X,Y] = smooth(X,Y)
	if (opt.s)
		% along first dimension
		[X_,Y_] = smooth_(X,Y,obj.id,obj.left,obj.right);
	else
		X_ = [];
		Y_ = [];
	end
	if (opt.n)
		% along second dimension
		[X_(:,end+1),Y_(:,end+1)] = smooth_(X,Y,obj.id,obj.up,obj.down);
	end
	
	% relaxation
	p = opt.relax;
	X = (1-p)*X + p*mean(X_,2);
	Y = (1-p)*Y + p*mean(Y_,2);

%	fdx = ~isfinite(X);
%	X(fdx) = X_old(fdx);
%	Y(fdx) = Y_old(fdx);
%	end
end % smooth

function [X,Y]=smooth_(X,Y,id,id1,id2)
	fdx   = isfinite(id) & isfinite(id1) & isfinite(id2);
	if (1)
		x0 = X(id(fdx));
		x1 = X(id1(fdx));
		x2 = X(id2(fdx));
		y0 = Y(id(fdx));
		y1 = Y(id1(fdx));
		y2 = Y(id2(fdx));
		[X(id(fdx)),Y(id(fdx))] = smooth1d_parametric(x0',y0',x1',y1',x2',y2');
	else
		P1=[X(id1(fdx)),Y(id1(fdx))]';
		P2=[X(id(fdx)),Y(id(fdx))]';
		P2=[X(id2(fdx)),Y(id2(fdx))]';
		P2 = smooth1d_parametric2(P1,P2,P3,opt.relax);
		X(id(fdx)) = P2(1,:);
		Y(id(fdx)) = P2(2,:);
	end % if 1
end % smooth_

end % smooth_curvilinear

