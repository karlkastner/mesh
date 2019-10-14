% Mo 26. Okt 20:21:52 CET 2015
% Karl Kastner, Berlin
%
% export edges for GIS import
%
function [shp shpe obj] = export_shp(obj,shpname)
%	edgeshpname = [shpname(1:end-4) '-edges.shp'];
	
%	P  = obj.point;
%	T  = obj.elemN3;
%	E  = obj.edge;
%	ne = obj.nedge;

	% export elements
%	shp = [];

	X = obj.elemX;
	Y = obj.elemY;
	Z = obj.elemZ;

%	X(:,end+1) = NaN;
%	Y(:,end+1) = NaN;
%	Z = mean(Z,2);
%	shp = [];
%	tic
%	shp(1:size(X,1)) = struct();
%	for idx=1:size(X,1);
%		shp(idx).X = X(idx,:);
%		shp(idx).Y = Y(idx,:);
%		shp(idx).Z = Z(idx);
%	end
%	[shp.Geometry] = deal('Polygon');
%	Shp.write(shp,[shpname(1:end-4),'-poly.shp']);
%	toc
%	n = 1e4;
%	X = X(1:n,:);
%	Y = Y(1:n,:)
%	Z = Z(1:n,:);

	X = mat2cell(X(:,1:3),ones(size(X,1),1),3);
	Y = mat2cell(Y(:,1:3),ones(size(Y,1),1),3);
	X = X';
	Y = Y';
	X{1}
	Y{1}
	Z = mean(Z,2);
	size(X)
	size(Z)
	tic
	polyname = [shpname(1:end-4),'-polygon.shp'];
	shapewrite_man(polyname,'Polygon',X,Y,'Z',rvec(Z));
	toc

%	for idx=3:size(obj.elem,3)
%	write_polygon(shpname, X, Y, Z);
%[P(T(:,1),1),P(T(:,2),1),P(T(:,3),1)], ...
%[P(T(:,1),2),P(T(:,2),2),P(T(:,3),2)]);

if (0)

	edgename = [shpname(1:end-4),'-edges.shp'];

	% fetch edges
	X = obj.edgeX();
	Y = obj.edgeY();

	% remove duplicates
	XY = unique([X Y],'rows');
	X = XY(:,1:2);
	Y = XY(:,3:4);

	% padd NaN to each row to indicate end of segment
	X(:,end+1) = NaN;
	Y(:,end+1) = NaN;

	% make a single vector (NaN is separator)
	X = flat(X');
	Y = flat(Y');

	% export
	shpe   = struct;
	shpe.Geometry = 'Line';
	shpe.X = X;
	shpe.Y = Y;

	if (nargin() > 0)
		Shp.write(shpe,edgename);
	end
end
end % export_shp

