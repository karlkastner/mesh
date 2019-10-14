% Thu 11 Jan 09:33:09 CET 2018
% Karl Kastner, Berlin
%
% first order first derivative discretisation matrix on the mesh
%
% TODO works only for tetras
function [Dx, Dy, Dz, obj] = derivative_matrix_3d(obj)
	% fetch
	elem  = obj.elem;
	nelem = size(elem,1);
	X = obj.elemX();
	Y = obj.elemY();
	Z = obj.elemZ();

	% shift to local coordinates to reduce rounding error
	% TODO scale to unit tetra?
	X    = bsxfun(@minus,X,X(:,1))';
	Y    = bsxfun(@minus,Y,Y(:,1))';
	Z    = bsxfun(@minus,Z,Z(:,1))';

	% vandermonde matrix of each element
	A        = ones(4,4,nelem);
	A(:,2,:) = X;
	A(:,3,:) = Y;
	A(:,4,:) = Z;
	Ai   = inv4x4(A);
	Dx   = squeeze(Ai(2,:,:));
	Dx   = reshape(Dx,[],1);
	Dy   = squeeze(Ai(3,:,:));
	Dy   = reshape(Dy,[],1);
	Dz   = squeeze(Ai(4,:,:));
	Dz   = reshape(Dz,[],1);

	buf1 = reshape(repmat((1:nelem),4,1),[],1);
	buf2 = double(reshape(elem',[],1));

	Dx = sparse(buf1,buf2,Dx);
	Dy = sparse(buf1,buf2,Dy);
	Dz = sparse(buf1,buf2,Dz);
end % derivative_matrix_3d

