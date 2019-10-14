% Do 1. Okt 12:32:16 CEST 2015
% Karl Kastner, Berlin

function [shp, obj] = export_shp(obj)
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
end % mesh export

