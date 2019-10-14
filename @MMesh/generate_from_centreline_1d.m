% Fri 18 Nov 07:26:45 CET 2016
% Karl Kastner, Berlin
% Static function
function obj = generate_from_centreline_1d(centreshp,Xc,Yc,Wc,Fc,resolution)
	obj = MMesh();

	shp = Shp.read(centreshp);

%	if (isstr(centre))
%		load(centre);
%	end

	shp = Shp.join_lines(shp);
	shp = Shp.cat(shp,NaN);
	if (nargin() > 4 && ~isempty(resolution))
		shp = Shp.resample(shp,resolution,false);
	end

	X  = cvec(shp.X);
	Y  = cvec(shp.Y);
	if (isfield(shp,'Z'))
		Z = shp.Z;
	else
		Z = NaN(size(X));
	end

	% vertex coordinates
	obj.point = [X Y Z];
	n = obj.np;

	% 1d elements (line segments)
	obj.elem = [(1:n-1)', (2:n)'];

	% remove nan points
 	% but not for vertical
	rdx = ~(isfinite(obj.X) & isfinite(obj.Y));
	obj.remove_points(rdx);

	obj.merge_duplicate_points();

	%
	% cross section width
	%

	% remove invalid points from centreline
	fdx = (isfinite(Xc) & isfinite(Yc) & isfinite(Wc));
	Xc = Xc(fdx);
	Yc = Yc(fdx);
	Wc = Wc(fdx);
	Fc = Fc(fdx);

	% assigne width from nearest cross section
	% the width is assigned to element centres, not points
	% width at points is ambiguous at bifurcations
	X = obj.X;
	Y = obj.Y;
	if (0)
		eX = mean(X(obj.elem(:,1:2)),2);
		eY = mean(Y(obj.elem(:,1:2)),2);

		[id dis]  = knnsearch([Xc Yc],[eX eY]);
		% TODO, that check distance is not too far
		obj.eval.width   = Wc(id);
		obj.eval.rgh     = Fc(id);
	else
		[id dis]  = knnsearch([Xc Yc],[X Y]);
		obj.pval.width = Wc(id);
		obj.pval.rgh   = Fc(id);
	end

end % from_centreline

