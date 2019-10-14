% Thu 18 Jan 15:11:54 CET 2018
function [Irmse rmse obj] = interpoltion_error_3d(obj,val,order)
	if (nargin()<3 || isempty(order))
		order = 0;
	end

	vol    = abs(obj.element_volume());

	switch (order)
	case {0} % for constant interpolation
		% s2 =  1/L int (f-f*)^2 dl = 1/3 f'^2 L^2

		% matrices of the first derivative
		[Dx Dy Dz]    = obj.derivative_matrix_3d();
		% first derivative (constant, thus midpoint rule is exact)
		dvdx = Dx*val;
		dvdy = Dy*val;
		dvdz = Dz*val;
		% mean square error per element
		% TODO scale factor
		msei  =   dvdx.^2 ...
		        + dvdy.^2 ...
		        + dvdz.^2;
	case {1} % error of linear interpolation
		% matrix of the second derivative
		[Dxx Dyy Dzz Dxy Dxz Dyz] = obj.derivative_matrix_3d_2();
		% second derivative (linear, thus midpoint rule is not exact)
		d2vdx2 = Dxx*val;
		d2vdy2 = Dyy*val;
		d2vdz2 = Dzz*val;
		d2vdxy = Dxy*val;
		d2vdxz = Dxz*val;
		d2vdyz = Dyz*val;
		% mean square error per element
		% TODO scale factor
		msei  =   d2vdx2.^2 ...
		       + d2vdy2.^2 ...
		       + d2vdz2.^2 ...
		       + 4*d2vdxy.^2 ...
		       + 4*d2vdxz.^2 ...
		       + 4*d2vdyz.^2;
	otherwise
		error('not yet implemented');
	end % switch order

	% root mean squared interpolation error over the entire mesh
	rmse  = sqrt(sum(mse.*vol)./sum(vol));
	% rmse per element
	rmsei = sqrt(msei);
end % interpolation_erro_3d

