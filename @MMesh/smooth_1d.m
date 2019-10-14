% Sun  4 Dec 16:03:45 CET 2016
% Sun  5 Feb 12:15:54 CET 2017
% Karl Kastner, Berlin
%
% smoothes values in each reach
% does not smooth the values at the connection points
%
function [val obj] = smooth_1d(obj,val, nsmooth)
	% chain 1d points
	chain_C = obj.chain_1d();
	for idx=1:length(chain_C)
		% get chain of current reach
		fdx = chain_C{idx};
		n = length(fdx);
		if (n>2)
		% smoothing kernel
		D = spdiags(  [ [1/4*ones(n-2,1);1/2;0], ...
				   1/2*ones(n,1), ...
                                  [0; 1/2; 1/4*ones(n-2,1)]], -1:1, n,n);
		% smooth
		val_ = D^(nsmooth)*val(fdx);
		% write back, do not overwrite values at connection points
		val(fdx(2:end-1)) = val_(2:end-1);
		end
	end % for jdx
% TODO curvature preserving 1d smoothing for coordinates
%-> put a circle to three points except for end and nodal points
%	if not almost colinear
%		- get vector a-centre,c-centre
%		- determine the half angle vectore
%		- get smoothed point
%		find the vector halving
%	-> move point 2
%	else
%		move point two to average of the other 2
end % smooth_1d

