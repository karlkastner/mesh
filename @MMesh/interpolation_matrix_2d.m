% Di 26. Jan 20:14:09 CET 2016
% Karl Kastner, Berlin
%
% linear interpolation matrix from mesh points to arbitrary coordinates P0,y0
%
% edx : index to containing triangles
% TODO vandermonde setup can be parrellised
% TODO inverse of the vandermonde matrix has explicit solution
% TODO, if reference is shifted and scaled and rotated to the unit triangle, vandermonde matrix stays the same !!!
% (only important for higher order)
% TODO use qtree (needs extension for multi-nearest neighbour)
% get the three nearest neighbour(s)
% TODO, this could be a mesh function, though, if mesh is sufficiently hierarchic
%jdx = knnsearch([obj.X,obj.Y],[P0,y0],'K',3);
function [A fdx edx obj] = interpolation_matrix_2d(obj,P0,edx,order)
	% TODO assign can directy return the interpolation coefficients C
	% for unassigned points, zero will be added to the first element of the matrix
	if (nargin() < 3 || isempty(edx))
		edx = obj.assign_2d(P0);
	end

	if (nargin() < 4 || isempty(order))
		% default is linear interpolation
		order = 1;
	end

	% skip non-convex points
	% TODO allow to choose nearest
	fdx = (edx > 0);

	% fetch element coordinates
	elem  = obj.elemN(3);
	elem  = elem(edx(fdx),1:3);
	eX    = reshape(obj.X(elem),[],3);
	eY    = reshape(obj.Y(elem),[],3);
	P0    = P0(fdx,:);

	% TODO reuse from assignment
	C = Geometry.tobarycentric2( [eX(:,1),eY(:,1)], ...
				     [eX(:,2),eY(:,2)], ...
				     [eX(:,3),eY(:,3)], P0 );

	n_   = sum(fdx); 
	buf1 = flat(ones(3,1)*(1:n_));
	buf2 = reshape(elem.',[],1);
	buf3 = flat(C);
	A    = sparse(buf1,buf2,buf3,n_,obj.np);
end % interpolation_matrix_2d

