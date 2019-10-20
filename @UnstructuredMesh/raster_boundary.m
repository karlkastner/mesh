% Di 15. Dez 17:09:39 CET 2015
% Karl Kastner, Berlin

function obj = raster_boundary(shp,h)
	% mesh the boundaries
	seg_C = Shp.segment(shp);
	seg_C = seg_C{1};
	Xb = [];
	Yb = [];
	E  = [];
	% w/o Nan separator
	Xb_ = [];
	Yb_ = [];
	E_  = [];
	obnd = 1/sqrt(2);
	oin = 0.5;
	for idx=1:size(seg_C,1)
		seg = seg_C(idx,1):seg_C(idx,2);
		nx = length(Xb)+1;
		nx_ = length(Xb_);
		[Xbi Ybi Ei] = UnstructuredMesh.mesh1(shp.X(seg),shp.Y(seg),obnd*h);
		Xb = [Xb; NaN; Xbi];
		Yb = [Yb; NaN; Ybi];
		E  = [E;Ei+nx+1];
		Xb_ = [Xb_; Xbi];
		Yb_ = [Yb_; Ybi];
		E_  = [E_;Ei+nx_];
		
	end
	
	% raster the domain in odd-even pattern
%	dx = sqrt(3)/2*h;
%	dy = h;
	dx = h;
	dy = sqrt(3)/2*h
	[X Y] = raster(shp.X,shp.Y,dx,dy);

figure(2)
clf()
plot(Xb,Yb,'b.-');
hold on
plot(X,Y,'k.');
length(X)

	% remove points outside the domain
	in = Geometry.inpolygon(Xb,Yb,X,Y);
	X = X(in);
	Y = Y(in);
plot(X,Y,'.g');

	% remove points close to boundary points
	[n dis] = knnsearch([Xb Yb],[X,Y]);
	%in = (dis >= 0.5*h);
	in = (dis >= oin*h);
	X = X(in);
	Y = Y(in);

	% constrained delaunay meshing
	P    = [Xb_, Yb_; X, Y];
        DT   = delaunayTriangulation(P,E_);
        elem = DT.ConnectivityList; 
	in   = isInterior(DT);
	elem = elem(in,:);

	obj = UnstructuredMesh();
	obj.point = P;
	obj.elem = elem;
end % raster_boundary

function [X Y] = raster(X,Y,dx,dy)
	xmin = min(X);
	xmax = max(X);
	ymin = min(Y);
	ymax = max(Y);
		
	nx = 2*ceil(0.5*(xmax-xmin)/dx);
	ny = 2*ceil(0.5*(ymax-ymin)/dy);

	x0 = xmin;
	y0 = ymin;

%	x0  = 0.5*(xmin+xmax);
%	y0  = 0.5*(ymin+ymax);
	
	x = x0+(0:nx-1)*dx;
	x = [x; x+0.5*dx];
	x = repmat(x,ny/2,1);
	size(x)
	y = y0+(0:ny-1)'*dy;
%	y = [y,y+0.5*dy];
	y = repmat(y,1,nx);
	size(y)
	
	X = x(:);
	Y = y(:);
end

