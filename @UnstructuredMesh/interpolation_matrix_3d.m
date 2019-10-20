% Thu 11 Jan 14:16:49 CET 2018
%
%% interpolation matrix for interpolation in 3D
function [A, fdx, edx, obj] = interpolation_matrix_3d(obj,P0,edx,order)
	% TODO assign can directy return the interpolation coefficients C
	% for unassigned points, zero will be added to the first element of the matrix
	if (nargin() < 3 || isempty(edx))
		edx = obj.assign_3d(P0);
	end

	if (nargin() < 4 || isempty(order))
		% default is linear interpolation
		order = 1;
	end

	% skip non-convex points
	% TODO allow to choose nearest
	fdx = (edx > 0);

	% fetch element coordinates
	elem  = obj.elemN(4);
	elem  = elem(edx(fdx),1:4);
	eX    = reshape(obj.X(elem),[],4);
	eY    = reshape(obj.Y(elem),[],4);
	eZ    = reshape(obj.Z(elem),[],4);
	P0    = P0(fdx,:);

	C = Geometry.tobarycentric3( [eX(:,1),eY(:,1),eZ(:,1)], ...
				     [eX(:,2),eY(:,2),eZ(:,2)], ...
				     [eX(:,3),eY(:,3),eZ(:,3)], ...
				     [eX(:,4),eY(:,4),eZ(:,4)], P0 );

	n_   = sum(fdx); 
	buf1 = flat(ones(4,1)*(1:n_));
	buf2 = reshape(elem.',[],1);
	buf3 = flat(C);
	A    = sparse(buf1,buf2,buf3,n_,obj.np);
end % interpolation_matrix_3d

