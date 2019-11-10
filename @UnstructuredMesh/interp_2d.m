% Thu 27 Jul 13:49:42 CEST 2017
% Karl Kastner, Berlin
%% interpolate on a 2D mesh
% function [v0, fdx] = interp_2d(obj,xy0,vi)
function [v0, fdx] = interp_2d(obj,xy0,vi)
	if (nargin() < 3)
		vi = obj.Z;
	end

	%  interpolation matrix
	[A, cflag, tdx] = obj.interpolation_matrix_2d(xy0);

%	v0 = NaN(size(xy0,1),size(vi,2));
	% interpolate
%	v0(cflag,:) = A*vi;
	v0 = A*vi;

	% TODO quick fix, nn can be returned by assign
%	fdx = find(isnan(v0));
%	if (length(fdx)>0)
%		k = knnsearch(mesh.point(:,1:2)
%	end	
end % interp_2d

