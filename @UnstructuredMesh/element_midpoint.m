% Mon May  2 10:09:19 CEST 2016
% Karl Kastner, Berlin
%
%% barymetric centre of elements
%
% save for quadriateras
function [c] = element_midpoint(obj,sdx)
	ndim = size(obj.point,2);
	c    = NaN(obj.nelem,ndim);
	for idx=2:size(obj.elem,2)
		[elemN fdx] = obj.elemN(idx);
		for jdx=1:ndim
			Xi = obj.point(:,jdx);
			Xi = Xi(elemN);
			%X          = reshape(obj.X(elemN),[],idx);
			%Y          = reshape(obj.Y(elemN),[],idx);
			c(fdx,jdx) = mean(Xi,2);
			%cxy(fdx,2) = mean(Y,2);
		end % for jdx
	end % for idx

	% TODO this is inefficient
	if (nargin() > 1)
		c = c(sdx,:);
		%cy = cy(sdx);
	end
end

