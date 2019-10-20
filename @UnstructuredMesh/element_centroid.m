% Wed 18 Jul 18:59:02 CEST 2018
%% centroids of lements
% TODO, what about 1D elements?
function [c,obj] = element_centroid(obj)
	c    = zeros(obj.nelem,2);
	for idx=3:size(obj.elem,2)
		[elem,fdx] = obj.elemN(idx);
		if (~isempty(elem))
			X = obj.point(:,1);
			X = X(elem);
			X = [X,X(:,1)];
			Y = obj.point(:,2);
			Y = Y(elem);
			Y = [Y,Y(:,1)];
			[cx,cy] = Geometry.centroid(X',Y');
			c(fdx,1)=cx;
			c(fdx,2)=cy;
			Z = obj.point(:,3);
			Z = Z(elem);
			c(fdx,3) = mean(Z,2);
		end % if
	end % idx
end % element_centroid

