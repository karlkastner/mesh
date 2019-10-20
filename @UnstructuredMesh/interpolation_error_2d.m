% Thu 27 Jul 12:08:27 CEST 2017
%% interpolate error in 2D
function [rmse rmsei obj] = interpolation_error_2d(obj,val,order)
	if (nargin()<3)
		order = 0;
	end

	area = abs(obj.element_area());

	switch (order)
	case {0} % int int (df/dx)^2 + (df/dy)^2 dx dy

		% matrices of the first derivative
		[Dx Dy] = obj.derivative_matrix_2d();
		% first derivative (constant, thus midpoint rule is exact)
		dvdx    = Dx*val;
		dvdy    = Dy*val;
		
		% mean square error per element
		% averaging by midpoint rule, this is exact for linear elements
		% TODO scale factor
		msei    = dvdx.^2 + dvdy.^2;

		%v3 = val(elem);
		% value at element centre
		%mu = mean(v3,2);
		%d  = bsxfun(@minus,v3,mu);
		% squared interpolation error per element
		% msei = rms(d,2); %mean(d.^2,2);
	case {1} % error of linear interpolation
		% int int  (d^2f/dx^2) + (2 d^2 f/dx^2)^2 + (d^2f/dy^2) dx dy
		% matrices of the second derivative
		[Dxx Dxy Dyy] = obj.derivative_matrix_2d_2();
		% partial derivatives of second order
		d2vdx2 = Dxx*val;
		d2vdxy = Dxy*val;
		d2vdy2 = Dyy*val;

		% midpoint rule, this is not exact
		% TODO scale factor
		msei =   d2vdx2.^2 ...
                       + (2*d2vdxy).^2 ...
                       + d2vdy2.^2;
	otherwise
		error('not yet implemented');
	end % switch order

	% root mean squared interpolation error over the entire mesh
	mse   = sqrt(sum(area.*msei)/sum(area));	
	% rmse per element
	rmsei = sqrt(msei);
end % inerpolation_error_2d

