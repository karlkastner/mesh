%- determine n closest points
%(- determine minimum level, get point indices)
%- get point coordinates
%- construct regression matrix
%- construct polynomial
%- derive polynomial
%- norm

% values defined at element centroids
% form nth-order derivative
function [A dval] = derivative_recursive(val)
-> edge based (first iteration)
-> element based

% TODO the basic derivativ matrix remains the same
	A  = 1;
	c  = val;
	% oder of polynomial:
	% x : n,n-1,n-2,...,0
	% y : 0,   1, 2,...,n
	for ddx=1:nd
		c__ = 0;
		% for each dimension
		for dim=0:1
			% for each derivative in the previous level
			for idx=1:length(c)
				% increase the order of the derivative
				nx_ = nx(idx) + dim;
				%ny_ = ny(idx) + (1-dim);
				% set up discretisation matrix
				A_ = 
				A_{idx+dim} = A_{idx+dim} + A{idx}*;
				% regress coefficients
				%c_ = A \ c;
				% accummulate coefficients
				%c__ = c__ 
			end
		end
		A = A*A__;
	end	
end

