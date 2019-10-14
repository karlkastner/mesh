% So 6. Dez 14:56:49 CET 2015
% Karl Kastner, Berlin
%
% determine interior angles for each element
%
% TODO this works currently only for triangles
% TODO this silently assume that the elements are triangles
function [cosa obj] = angle(obj,fdx)
%	if (nargin() < 2)
%		[elem3 fdx] = obj.elemN(3);
%	end

	if (nargin()<2)
		X = obj.elemX();
		Y = obj.elemY();
	else
		X = obj.elemX(fdx);
		Y = obj.elemY(fdx);
	end
%	if (islogical(fdx))
%		n = sum(fdx);
%	else
%		n = length(fdx);
%	end

	% allocate memory
	%cosa = NaN(n,3);

	% for each angle of the triangles
	dXl = left(X)-X;
	dYl = left(Y)-Y;
	dXr = right(X)-X;
	dYr = right(Y)-Y;
	
%	l = obj.left; 
%	r = obj.right;
%	for idx=1:3
%		dXl = X(:,l(idx)) - X(:,idx);
%		dYl = Y(:,l(idx)) - Y(:,idx);
%		dXr = X(:,r(idx)) - X(:,idx);
%		dYr = Y(:,r(idx)) - Y(:,idx);
%		cosa(:,idx) = Geometry.dot(dXl(:,idx),dYl(:,idx),dXr(:,idx),dYr(:,idx));
%	end % for idx
	cosa = Geometry.dot(dXl(:),dYl(:),dXr(:),dYr(:));
	
	% make 3 columns
	cosa = reshape(cosa,[],3);

%	if (nargin() < 2)
%		cosa_ = NaN(obj.nelem,3);
%		cosa_(fdx,:) = cosa;
%		cosa = cosa_;
%	end
end % angle

