% Do 1. Okt 12:32:16 CEST 2015
% Karl Kastner, Berlin
%% export mesh elements as shape file
function [shp, obj] = export_shp(obj,filename)
	X = full(obj.X);
	Y = full(obj.Y);
	E = obj.elem;
	shp = struct();
	for idx=1:size(E,1)
		x = X(E(idx,:));
		y = Y(E(idx,:));
		shp(idx).X = [rvec(x), x(1)];
		shp(idx).Y = [rvec(y), y(1)];
		shp(idx).Geometry = 'Line';
	end
	if (nargin()>1)
		Shp.write(shp,filename);
	end
end % mesh export

