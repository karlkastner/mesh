% Thu 22 Jun 09:36:51 CEST 2017
% Karl Kastner, Berlin
%
% assign coordinatex (x0,y0) to containing element
%
function [edx cflag nn obj] = assign_1d(obj,x0)
	% allocate memory for each segment
	nx            = length(x0);
	fdx           = zeros(nx,1);
	v2e	      = obj.vertex_to_element();
	%elem          = obj.elemN(2);
	%X	      = obj.X;

	% nearest mesh point
	ndx = knnsearch(obj.X,cvec(x0),'K',1);

	% get elements the nearest mesh points are part of
	[row col] = find(v2e(ndx,:));

	% repeat point coordinates
	x0 = x0(row);

	% associated element coordiantes
	X = obj.elemX;
	X = X(col,1:2);
	%X = X(elem(row,:));
	%reshape(X(elem(col,:)),[],3);

	% test if contained
	[flag c] = Geometry.onLine(X,cvec(x0));
	
	% point index
	p      = row(flag);
	% element index
	e      = col(flag);

	% element index
	edx    = zeros(nx,1); %obj.nelem,1); %size(ndx));
	edx(p) = e;
	
	% convex points
	cflag = (edx~=0);

	% count number of points per element
	%n     = sum(cflag);
	%nn    = accumarray(edx(cflag),ones(n,1),[n,1]);
	nn    = accumarray(edx(cflag),ones(sum(cflag),1),[obj.nelem,1]);
end % assign

