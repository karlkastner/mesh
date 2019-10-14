% So 14. Feb 14:21:57 CET 2016
% Karl Kastner, Berlin
%
% refine mesh by inserting steiner points (centre of circumference)
% for elements specified by tdx
%
function obj = insert_steiner_points(obj,tdx)

	if (islogical(tdx))
		tdx = find(tdx);
	end
	printf('Inserting %d Steiner points\n',length(tdx));

	%
	% determine which Steiner points are outside the domain
	%

	% get obtuse angle index
	cosa = obj.angle(tdx);
	[cosa mdx] = min(cosa');

	% get edge indices for each obtuse element
	elem = obj.elem(tdx,:);
	% TODO make a function elemedge
	edge  = zeros(length(tdx),2);
	left  = obj.left(mdx);
	right = obj.right(mdx);
	for idx=1:length(tdx)
		edge(idx,1) = obj.elem(tdx(idx),left(idx));
		edge(idx,2) = obj.elem(tdx(idx),right(idx));
	end
	bnd = obj.edge(obj.bnd,:);
	% sort
	bnd  = sort(bnd')';
	edge = sort(edge')';
	% determine if edge is a boundary edge
	bflag = false(size(tdx));
	for idx=1:length(tdx)
		bflag(idx) = (0 == min(  abs(bnd(:,1)-edge(idx,1)) + abs(bnd(:,2)-edge(idx,2))));
	end

%	figure(1);
%	clf
%	col = zeros(obj.nelem,1);
%	col(tdx(bflag)) = 1;
%	trisurf(obj.elem,obj.point(:,1),obj.point(:,2),[],col,'edgecolor','k');
%	view(0,90);

	bflag = find(bflag);
	elem  = elem(bflag,:);
	mdx   = mdx(bflag);
	left  = left(bflag);
	right = right(bflag);
	printf('%d obtuse edges coincide with a boundary\n',length(bflag));
	for idx=1:length(bflag)
		% the new elements are 
		c = elem(idx,mdx(idx));
		l = elem(idx,left(idx));
		r = elem(idx,right(idx));

		% add mid-point
		% TODO, not midpoint, but point on plumb line
		obj.point(obj.np+1,:) = 0.5*(obj.point(l,:) + obj.point(r,:));
		np = obj.np;
		% update element
		obj.elem(tdx(bflag(idx)),1:3)    = [l, c,np];
		% add new element
		obj.elem(obj.nelem+1,1:3) = [np,c,r];
	end
	% TODO update boundary inside loop
	obj.edges_from_elements();

%	figure(2);
%	clf
%	col = zeros(obj.nelem,1);
%	col(tdx(bflag)) = 1;
%	trisurf(obj.elem,obj.point(:,1),obj.point(:,2),[],col,'edgecolor','k');
%	view(0,90);
%pause

	% remove the processed triangles from the processing queue
	tdx(bflag) = [];

	%
	% interior triangles
	%

	% get old obj boundary in point index form
	bnd = obj.edge(obj.bnd,:);

	% get old obj points
	X = obj.point(:,1);
	Y = obj.point(:,2);

%	X = X(obj.elem);
%	Y = Y(obj.elem);
	P = [X,Y];
	if (length(tdx) > 0)
	if (length(tdx) == 1)
		x_ = rvec(X(obj.elem(tdx,:)));
		y_ = rvec(Y(obj.elem(tdx,:)));

		% get centre of tri_excircle of requrested elements
		[Xc Yc R] = Geometry.tri_excircle(x_,y_);
	else
		[Xc Yc R] = Geometry.tri_excircle(X(obj.elem(tdx,:)),Y(obj.elem(tdx,:)));
	end
	
	% add these points to the point mesh
	P = [P; Xc,Yc];
	end
if (1)
	obj.point = P;
	obj.retriangulate();
else
	% reobj
	% TODO efficient implementation, remeshing of the complete mesh not necessary
	DT = delaunayTriangulation(P,bnd);
	T  = DT.ConnectivityList;
	% remove triangles outside the domain
	in = isInterior(DT);
	T = T(in,:);

	% TODO, check points outside of the domain,
	% for those triangles, split them at the projected point

	obj.elem  = T;
	obj.point = DT.Points;
	obj.remove_isolated_vertices();
	obj.edges_from_elements();
end
end % insert steiner points

