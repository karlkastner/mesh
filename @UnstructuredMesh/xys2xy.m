% Mon 21 Nov 15:41:11 CET 2016
% Karl Kastner, Berlin
%
%% convert parametric 1D coordinate of boundary point back to cartesian XYc oordinate 
function [XY dXY flag flagx flagy flagi] = xys2xy(obj,XYS,order)
	XY0 = obj.point(:,1:2);

	% boundary vertex indices
	bnd1 = obj.bnd1;
	% number of boundary points
	nb   = length(bnd1);
	% number of interior points
	ni   = obj.np - nb;
	flag = false(obj.np,1);
	flag(bnd1) = true;
	% boundary chain centre, left, right
	bnd3 = obj.bnd3;

%	flag            = false(obj.np,1);
%	flag(bnd3(:,1)) = true;
	flagx  = [flag; false(obj.np,1)];
	flagy  = [false(obj.np,1); flag];
	% indices of interior points
	flagi  = ~(flagx | flagy);

	% store original coordinates
	%XY0 = obj.point(:,1:2);

	% unstack the interior point coordinates
	%XY          = zeros(obj.np,2);
	%XY(~flag,:) = reshape(XYS(1:2*ni),[],2);

	% interior points
	XY = XY0;
	XY(~flag,1) = XYS(1:ni);
	XY(~flag,2) = XYS(ni+1:2*ni);

	switch (order)
	case {0} % constant boundary
		% nothing to do, boundary points remain fixed
		dXY = [];

%		XY = XY0;
%		XY(flagx,1) = XYS(1:ni);
%		XY(flagy,1) = XYS(ni+1:end);
%		XY(flag,1) = obj.X(bnd3(:,1));
%		XY(flag,2) = obj.Y(bnd3(:,1));
%		flagx = [];
%		flagy = [];
	case {1} % linear boundary
		S = XYS(2*ni+1:end);

		% tangent slope at the boundary
		dx = obj.X(bnd3(:,3))-obj.X(bnd3(:,2));
		dy = obj.Y(bnd3(:,3))-obj.Y(bnd3(:,2));
		% normalise
		d  = hypot(dx,dy);
		dx = dx./d;
		dy = dy./d;	
		dXY = [dx,dy];

		% evaluate coordinates at the boundary points as parametric (linear) function
		XY(flag,1) = obj.X(bnd3(:,1)) + dx.*S;
		XY(flag,2) = obj.Y(bnd3(:,1)) + dy.*S;
	case {2} % quadaratic boundary
		X = obj.X;
		Y = obj.Y;
		S  = XYS(2*ni+1:end);

		% parametric vandermonde matrix at origin
		h = 0.01;
		A0 = [1  0 0;  % centre
		      1 -h h.^2;  % left
                      1  h h.^2]; % right
		% coefficients
		cx = A0 \ X(bnd3)';
		cy = A0 \ Y(bnd3)';
		% parametric vandermonde row at vertex
		A = [ones(nb,1),S,S.^2]';
		% derivative matrix at vertex
		D = [zeros(nb,1),ones(nb,1),2*S]';
		% tangent slope at the boundary
		dx = sum(cx.*D,1)';
		dy = sum(cy.*D,1)';
		% normalise
		d   = hypot(dx,dy);
		dx  = dx./d;
		dy  = dy./d;
		dXY = [dx,dy];
		% coordinates at the boundary
		XY(flag,1) = sum(cx.*A,1)';
		XY(flag,2) = sum(cy.*A,1)';
	end % switch order
end % xys2xy

