% Thu 27 Jul 13:49:42 CEST 2017
% Karl Kastner, Berlin
%% interpolate on a 2D mesh
function [v0, fdx] = interp_2d(obj,xy0,vi)

	%  interpolation matrix
	[A, cflag, tdx] = obj.interpolation_matrix_2d(xy0);

	v0 = NaN(size(xy0,1),size(vi,2));

	% interpolate
	v0(cflag,:) = A*vi;

end % interp_2d

