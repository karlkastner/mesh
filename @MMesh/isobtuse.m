% Mo 2. Nov 18:11:55 CET 2015
% Karl Kastner, Berlin
function [isacute Xc Yc R obj] = isobtuse(obj)
	% fetch vertex coordinates
	isacute     = NaN(obj.nelem,1);
	[elem3 fdx] = obj.elemN(3);
	X     = obj.elemX(fdx);
	Y     = obj.elemY(fdx);
%	X = reshape(X(elem3),[],3);
%	Y = reshape(Y(elem3),[],3);
	[isacute(fdx) Xc Yc] = Geometry.tri_isobtuse(X,Y);
end % isacute

