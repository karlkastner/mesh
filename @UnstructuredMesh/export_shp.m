% Mo 26. Okt 20:21:52 CET 2015
% Karl Kastner, Berlin
%
%% export edges to GIS shapefile
%% each element as separate polygon with one z-value
%
function [shp, shpe, obj] = export_shp(obj,shpname)

	X = obj.elemX;
	Y = obj.elemY;
	Z = obj.elemZ;

	X = mat2cell(X(:,1:3),ones(size(X,1),1),3);
	Y = mat2cell(Y(:,1:3),ones(size(Y,1),1),3);
	X = X';
	Y = Y';
	Z = mean(Z,2);

	polyname = [shpname(1:end-4),'-polygon.shp'];
	% export the shapefile
	% the matlab buildin shapewrite is extremely slow
	% the custom implemenation is much faster
	shapewrite_man(polyname,'Polygon',X,Y,'Z',rvec(Z));
end % export_shp

