% Thu 11 Jan 10:15:55 CET 2018
% Karl Kastner, Berlin
%
% assign coordinatex (P0,y0) to containing element
%
function [tdx, cflag, nn, obj] = assign_3d(obj,P0)

	if (1)
	% TODO this is a quick hack and should better be solved with a multidimensional tree

	Pc   = obj.element_midpoint();
	tdx  = knnsearch(Pc(:,1:3),P0,'K',1);
	elem = obj.elem;
	elem = elem(tdx,1:4);
	% check bounding box
	cflag = true(size(P0,1),1);
	for idx=1:3
		X = obj.point(:,idx);
		X = X(elem);
		%    = reshape(obj.point(elem,idx));
		cflag = cflag ...
                        & (P0(:,idx) >= min(X,[],2)) ...
                        & (P0(:,idx) <= max(X,[],2));
	end % for idx
	
	else
	% this does not work always, the nearest vertex is not necessarily
	% a vertex of the containing tetra (or triangle)

	elem          = obj.elemN(4);
	A	      = obj.vertex_to_element();
	X	      = obj.X;
	Y	      = obj.Y;
	Z	      = obj.Z;

	% nearest mesh point
	[ndx dis] = knnsearch(obj.point(:,1:3),P0,'K',1);

	% get elements the nearest mesh points are part of
	[row, col] = find(A(ndx,:));

%	[fdx_ Tdx C] = obj.test_assign(P0,y0);

	% repeat point coordinates
	P0_   = P0(row,:);
	elem_ = elem(col,:);

	% associated element coordiantes
	X_ = X(elem_);
	Y_ = Y(elem_);
	Z_ = Z(elem_);
%	X = reshape(X(elem),[],3);
%	Y = reshape(Y(elem),[],3);

	% test if contained
	%[flag] = Geometry.inTetra(X_,Y_,Z_,P0_(:,1),P0_(:,2),P0_(:,3));
	%[flag, c] = Geometry.inTetra(X_,Y_,Z_,P0_(:,1),P0_(:,2),P0_(:,3));
	[flag, c] = Geometry.inTetra2(  [X_(:,1),Y_(:,1),Z_(:,1)], ...
					[X_(:,2),Y_(:,2),Z_(:,2)], ...
					[X_(:,3),Y_(:,3),Z_(:,3)], ...
					[X_(:,4),Y_(:,4),Z_(:,4)], ...
					P0_); % no transpose

	
	pdx      = row(flag);
	edx      = col(flag);

	% element index
	tdx      = zeros(size(ndx));
	tdx(pdx) = edx;

%	c_ = accummarray(

	% count number of points per element
	cflag = (tdx~=0);
	end

	n     = sum(cflag);
	ne    = obj.nelem;
	nn    = accumarray(tdx(cflag),ones(n,1),[ne,1]);
	
	% accummulate (mimimum index (first only))
%	fdx = accumarray(ndx(row),c.*col,[obj.np,1],@min);
%	toc
%	norm(fdx-fdx_)
%	pause
end % assign

