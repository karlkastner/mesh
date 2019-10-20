% So 6. Dez 15:39:11 CET 2015
% Karl Kastner, Berlin
%
%% area of elements
%% 1d elements have zero area and are not processed
% TODO allow for selection of elements
function [a obj] = element_area(obj)
	a = zeros(obj.nelem,1);
	
	for idx=3:size(obj.elem,2);
		[elem, fdx] = obj.elemN(idx);
		if (~isempty(fdx))
%		X = obj.elemX(fdx);
%		Y = obj.elemY(fdx);
		X = reshape(obj.X(elem(:,1:idx)),[],idx);
		Y = reshape(obj.Y(elem(:,1:idx)),[],idx);

		X = [X,X(:,1)];
		Y = [Y,Y(:,1)];
		a(fdx) = Geometry.poly_area(X',Y');
		end
	end
end
