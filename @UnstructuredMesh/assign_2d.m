% Do 28. Jan 08:14:13 CET 2016
% Karl Kastner, Berlin
%
%% assign coordinatex (x0,y0) to containing element
%
function [tdx, cflag, nn, obj] = assign_2d(obj,P0)
	% allocate memory for each segment
	n             = size(P0,1);
	fdx           = zeros(n,1);
	elem          = obj.elemN(3);
%	[pt el A]     = obj.point_to_elem();
	A	      = obj.vertex_to_element();
	X	      = obj.X;
	Y	      = obj.Y;

	% nearest mesh point
	ndx = knnsearch(obj.point(:,1:2),P0,'K',1);

	% get elements the nearest mesh points are part of
	[row, col] = find(A(ndx,:));

%	[fdx_ Tdx C] = obj.test_assign(x0,y0);

	% repeat point coordinates
	P0_   = P0(row,:);
	elem_ = elem(col,:);

	% associated element coordiantes
	X_ = X(elem_);
	Y_ = Y(elem_);
%	X = reshape(X(elem),[],3);
%	Y = reshape(Y(elem),[],3);

	% test if contained
	%[flag c] = Geometry.inTriangle(X_,Y_,P0_(:,1),P0_(:,2));
	%c_ = Geometry.tobarycentric(X_,Y_,P0_(:,1),P0_(:,2));
	[flag, c] = Geometry.inTriangle( [X_(:,1),Y_(:,1)], ...
	 				 [X_(:,2),Y_(:,2)], ...
					 [X_(:,3),Y_(:,3)], ...
					 P0_ );

	
	pdx      = row(flag);
	edx      = col(flag);

	% element index
	tdx      = zeros(size(ndx));
	tdx(pdx) = edx;

%	c_ = accummarray(

	% count number of points per element
	cflag = (tdx~=0);
	n     = sum(cflag);
	ne    = obj.nelem;
	nn    = accumarray(tdx(cflag),ones(n,1),[ne,1]);
	
	% accummulate (mimimum index (first only))
%	fdx = accumarray(ndx(row),c.*col,[obj.np,1],@min);
%	toc
%	norm(fdx-fdx_)
%	pause
end % assign

