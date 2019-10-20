% Sun  5 Feb 14:49:56 CET 2017
% Karl Kastner, Berlin
%
%% linear interpolation matrix from mesh points to arbitrary coordinates P0
%
function [A, fdx, edx, obj] = interpolation_matrix_1d(obj,P0,edx,order)

	% assign samples to elements
	if (nargin() < 3||isempty(edx))
		edx  = obj.assign_1d(P0);
	end

	if (nargin() < 4 || isempty(order))
		% default is linear interpolation
		order = 1;
	end

	% skip non-convex points
	% TODO allow to choose nearest
	fdx  = (edx > 0);

	% fetch element coordinates
	elem  = obj.elemN(2);
	elem  = elem(edx(fdx,:),1:2);
	eX    = reshape(obj.X(elem),[],2);
%	eX    = X(elem);
	P0    = P0(fdx);
	
	C    = Geometry.tobarycentric1(eX(:,1),eX(:,2),P0);

	n_   = sum(fdx); 
	buf1 = flat(ones(2,1)*(1:n_));
	buf2 = reshape(elem.',[],1);
	buf3 = flat(C);
	A    = sparse(buf1,buf2,buf3,n_,obj.np);

end % interpolation_matrix_1d

