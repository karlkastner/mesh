% Sun  5 Feb 14:49:56 CET 2017
% Karl Kastner, Berlin
%% interpolate on a 1D mesh
function [val, fdx] = interp1_1d(obj,x0,y0,v0)
	fdx = isfinite(x0) & isfinite(y0) & isfinite(v0);
	if (sum(~fdx)>0)
		warning('Discarding invalid points');
		x0 = x0(fdx);
		y0 = y0(fdx);
		v0 = v0(fdx);
	end
	elem2 = double(obj.elemN(2));
	fdx   = false(obj.np,1);
	fdx(elem2(:)) = true;

	%  constant interpolation matrix
	A = obj.interpolation_matrix_1d(x0,y0);

	% right hand size
	rhs = cvec(v0);

	% first deriviative matrix
	[D1s, D1x, D1y, edx, pdx] = obj.derivative_matrix_1d();

	% only 1d part
	A(:,~pdx)   = [];
	D1s         = D1s(edx,:);
	D1s(:,~pdx) = [];
	D1x         = D1x(edx,:);
	D1x(:,~pdx) = [];
	D1y         = D1y(edx,:);
	D1y(:,~pdx) = [];

	% inner product (quasi second derivative)
	DDs = D1s'*D1s;

	% zero the element indices where values are given
	%DDs(id,:) = 0;

	% solve tikhonov regularised interpolation problem
	s = 1;
	val = (A'*A + s*DDs)\(A'*rhs);
	% TODO filter values that are disconnected and solve directly
	%val = pinv(full(A'*A + s*DDs))*(A'*rhs);
end % interp_1d

