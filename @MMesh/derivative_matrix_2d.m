% 2016-04-19 15:41:45.840937591 +0200
% Karl Kastner, Berlin
%
% first order first derivative discretisation matrix on the mesh
%
% TODO works only for triangles
function [Dx Dy obj] = derivative_matrix_2d(obj)
	% fetch
	elem = obj.elem;
	nelem = size(elem,1);
	X = obj.elemX();
	Y = obj.elemY();

	% shift to local coordinates to reduce rounding error
	% TODO scale to unit triangle?
	X    = bsxfun(@minus,X,X(:,1))';
	Y    = bsxfun(@minus,Y,Y(:,1))';

	% vandermonde matrix of each element
	A   = ones(3,3,nelem);
	A(:,2,:) = X;
	A(:,3,:) = Y;
	Ai  = inv3x3(A);
	Dx  = squeeze(Ai(2,:,:));
	Dx   = reshape(Dx,[],1);
	Dy   = squeeze(Ai(3,:,:));
	Dy   = reshape(Dy,[],1);
	buf1 = reshape(repmat((1:nelem),3,1),[],1);
	buf2 = double(reshape(elem',[],1));

	Dx = sparse(buf1,buf2,Dx);
	Dy = sparse(buf1,buf2,Dy);
end % derivative_matrix_2d

