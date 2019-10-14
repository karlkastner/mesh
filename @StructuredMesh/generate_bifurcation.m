% Sat 24 Feb 14:46:24 CET 2018

% creates a bluff, which is required for delft3d meshes
% TODO do not fix indices
% TODO determine p individually

% bank : bankline shapefile
% nn : number of points across branches
% ds: spacing along s
% p : fraction of right side branch
% level : generate hierarchical mesh,
%	  grid points in each branch will be 2^n+1,
%	  and sub meshes until level 1 will be generated
%
% for lower levels the connecting volumes remain narrow,
% as the two volumes left and right of the division line are not scaled
% -> post smoothing required
%
% nn: n=6; for idx=1:5; n(end+1)  = 2*(n(end)-3)+3, end
% ns: n=18; for idx=1:5; n(end+1) = 2*(n(end)-2)+2, end (should be improved to 2*(n-1)+1
function [smesh, obj] = generate_bifurcation(obj,bank,nn,ds,p,id_offset,level)
%	p  = 1/3;
%	jd = [3]

	if (nargin() < 7 || isempty(level))
		% no hierarchical sub-meshes
		level = 0;
	end

	jd.left  = 2;
	jd.right = 3;
	jd_ = [1,2,3];
	
	method = 'linear';
	%if (length(nn)<2)
	%	nn(2) = nn(1);
	%end

	% scale up number of points along n for branches
	nn(2:3) = 2.^level*(nn(2:3)-1)+1;
	nn(2:3) = round(nn(2:3));
	nn(2:3) = max(nn(2:3),2);
%	nn(2:3) = 2.^level*round(nn(2:3)/2.^level)+1;
%	if (nn(2)<nn(1))
%	end

	%
	% mesh approaching channel
	% 

	% mid-channel-line in approaching channel
	[id,dis] = knnsearch([ cvec(bank(jd.right).X), cvec(bank(jd.right).Y)], ...
			     [ cvec(bank(jd.left).X), cvec(bank(jd.left).Y)]);
	l(1).X      = cvec(p*bank(jd.left).X + (1-p)*bank(jd.right).X(id));
	l(1).Y      = cvec(p*bank(jd.left).Y + (1-p)*bank(jd.right).Y(id));

	% corresponding points on left, these are only used to find the mid-index
	% TODO, it is not necessary to rerun-knnsearch
	% TODO use higher order
	if (1)
	jd = 1;	
	[id1,dis1] = knnsearch( ...
				[cvec(bank(jd).X),cvec(bank(jd).Y)], ...
				[l(1).X,l(1).Y] ...
				);
	else
	jd = 1;
	[XY,id1,p1,dis1] = Geometry.project_to_curve( ...
				[cvec(bank(jd).X),cvec(bank(jd).Y)], ...
				[l(1).X,l(1).Y] ...
				);
	XY(:,1) = XY(:,1)+sqrt(eps)*(1:size(XY,1))';
	end

	% corresponding points on right
	jd = 3;
	[id3,dis3] = knnsearch( ...
				[cvec(bank(jd).X),cvec(bank(jd).Y)], ...
				[l(1).X,l(1).Y] ...
				);

	% bifurcation midpoint
	[dis_,id_] = min(dis1+dis3);
	id_ = id_+id_offset;

	l(2).X = flipud(cvec(bank(1).X(1:id1(id_))));
	l(2).Y = flipud(cvec(bank(1).Y(1:id1(id_))));
	l(3).X = cvec(bank(1).X(id1(id_):end));
	l(3).Y = cvec(bank(1).Y(id1(id_):end));

if (0)
	l(2).X = flipud(XY(1:id1(id_),1));
	l(2).Y = flipud(XY(1:id1(id_),2));
	l(3).X = (XY(id1(id_):end,1));
	l(3).Y = (XY(id1(id_):end,2));
end

	% truncate mid-channel-line at bifurcation mid-point
	l(1).X(id_+1:end) = [];
	l(1).Y(id_+1:end) = [];

	% append to mid-channel-line the bifurcation point
	% NOTE: this is a matlab-bug workaround
	% several points on the connecting line are added here,
	% as otherwise interpolation fails
	p_     =  (1:4)'/4;
	l(1).X = [l(1).X; p_*l(2).X(1)+(1-p_)*l(1).X(end)];
	l(1).Y = [l(1).Y; p_*l(2).Y(1)+(1-p_)*l(1).Y(end)];

	for idx=1:3
		l(idx).S = cvec(Geometry.arclength(l(idx).X,l(idx).Y));
	end

	% TODO, curvature correction

	% number of grid points along approaching channel and downstream branches
	if (isempty(ds))
		% number of points along the approaching branch
		pn    = [l(1).S(end), 0.5*(l(2).S(end)+l(3).S(end))];
		pn    = pn/sum(pn);
		ns    = round(pn(1)*nn(1));
		ns(2) = nn(1)-ns(1);
		% refine
		ns    = 2^level*(ns-1)+1;
		ns(2) = ns(2)+1; % as last is removed
	else
		% approaching branch
		n       = l(1).S(end)/ds;
		n	= 2.^level*round(n/2.^level)+1;
		ns(1)   = max(2,n);

		% number of points along downstream branches is chosen to be equal here
		n       = 0.5*(l(2).S(end)+l(3).S(end))/ds;
		% here not +1, as further down the first is removed
		n	= 2.^level*round(n/2.^level)+2;
		ns(2)   = max(2,n);
	end
	
	% resample grid points along the approaching channel
	if (1)
		l(1).Si = (0:ns(1)-1)'/(ns(1)-1)*l(1).S(end);
	else
		l(1).Si = logspace_trimmed(l(1).S(end),dsmin,dsmax,p)';
	end

	% resample grid points along downstream branches
	if (1)
		l(2).Si = (0:ns(2)-1)'/(ns(2)-1)*l(2).S(end);
		l(3).Si = (0:ns(2)-1)'/(ns(2)-1)*l(3).S(end);
	else
		l(2).Si = logspace_trimmed(l(2).S(end),dsmin,dsmax,p)';
		l(3).Si = l(2).Si*l(3).S(end)/l(2).Si(end);
	end

	% SN to XY
	for idx=1:3
		l(idx).Xi = interp1_save(l(idx).S,l(idx).X,l(idx).Si,method);
		l(idx).Yi = interp1_save(l(idx).S,l(idx).Y,l(idx).Si,method);
	end

if (0)
	figure(1000)
	clf
	Shp.plot(bank)
	hold on
	for idx=1:3
		plot(l(idx).Xi,l(idx).Yi,'.')
		hold on
	end
%		pause
end

	% concatenate mid-channel-line in approaching channel,
	% with left and right bank below bifurcation point
	n0 = length(l(1).Xi)-1;
	l(2).Xi = [l(1).Xi(1:end-1);l(2).Xi];
	l(2).Yi = [l(1).Yi(1:end-1);l(2).Yi];
	l(3).Xi = [l(1).Xi(1:end-1);l(3).Xi];
	l(3).Yi = [l(1).Yi(1:end-1);l(3).Yi];

	X = [];
	Y = [];

	% nearest neighbour on opposit bank
	[XY_{1}] = Geometry.project_to_curve( ...
					[cvec(bank(2).X),cvec(bank(2).Y)], ...
					[cvec(l(2).Xi),cvec(l(2).Yi)]);
	X_{1} = XY_{1}(:,1);
	Y_{1} = XY_{1}(:,2);
	% TODO higher order
%	[id1,dis1] = knnsearch( ...
%			[cvec(bank(2).X),cvec(bank(2).Y)], ...
%			[cvec(l(2).Xi),cvec(l(2).Yi)] ...
%			);
%	X_{1} = cvec(bank(2).X(id1));
%	Y_{1} = cvec(bank(2).Y(id1));


	% grid points first half of approaching channel and first branch
	q  = (0:nn(2)-1)/(nn(2));
	q_ = (0:nn(2)-1)/(nn(2)-1);
	X_C{1} = [l(2).Xi(1:n0+1)*q    + X_{1}(1:n0+1)*(1-q)];
	X_C{3} = [l(2).Xi(n0+2:end)*q_ + X_{1}(n0+2:end)*(1-q_)];
	Y_C{1} = [l(2).Yi(1:n0+1)*q    + Y_{1}(1:n0+1)*(1-q)];
	Y_C{3} = [l(2).Yi(n0+2:end)*q_ + Y_{1}(n0+2:end)*(1-q_)];

%	X = [X, [l(2).Xi(1:n0+1)*q    + X_{1}(1:n0+1)*(1-q); ...
%		 l(2).Xi(n0+2:end)*q_ + X_{1}(n0+2:end)*(1-q_)]];
%	Y = [Y, [l(2).Yi(1:n0+1)*q    + Y_{1}(1:n0+1)*(1-q); ...
%		 l(2).Yi(n0+2:end)*q_ + Y_{1}(n0+2:end)*(1-q_)]];

	[XY_{2}] = Geometry.project_to_curve( ...
					[cvec(bank(3).X),cvec(bank(3).Y)], ...
					[cvec(l(3).Xi),cvec(l(3).Yi)]);
	XY_{2}(1,:) = [bank(3).X(end),bank(3).Y(end)];

	X_{2} = XY_{2}(:,1);
	Y_{2} = XY_{2}(:,2);
%	[id1,dis1] = knnsearch( ...
%			[cvec(bank(3).X),cvec(bank(3).Y)], ...
%			[cvec(l(3).Xi),cvec(l(3).Yi)] ...
%			);
%	X_{2} = cvec(bank(3).X(id1));
%	Y_{2} = cvec(bank(3).Y(id1));

	% grid points second half of approaching channel and second branch
	% the mid-channel line was created for the previous branch, so index goes only to n-1
	q_ = fliplr((0:nn(3)-1)/(nn(3)-1));
	q  = fliplr((0:nn(3)-1)/(nn(3)));
	n0_ = n0+1;

	X_C{2} = [NaN(size(X_C{1},1),0), l(3).Xi(1:n0_)*q + X_{2}(1:n0_)*(1-q)];
	X_C{4} = [l(3).Xi(n0_+1:end)*q_    + X_{2}(n0_+1:end)*(1-q_)];
	Y_C{2} = [NaN(size(X_C{1},1),0), l(3).Yi(1:n0_)*q  + Y_{2}(1:n0_)*(1-q)];
	Y_C{4} = [l(3).Yi(n0_+1:end)*q_    + Y_{2}(n0_+1:end)*(1-q_)];

	% spine in combined channel
	Xs = l(3).Xi(1:n0_);
	Ys = l(3).Yi(1:n0_);

%	X = [X, [l(3).Xi(1:n0_)*q + X_{2}(1:n0_)*(1-q); ...
%		 l(3).Xi(n0_+1:end)*q_ + X_{2}(n0_+1:end)*(1-q_)]];
%	Y = [Y, [l(3).Yi(1:n0_)*q + Y_{2}(1:n0_)*(1-q); ...
%		 l(3).Yi(n0_+1:end)*q_ + Y_{2}(n0_+1:end)*(1-q_)]];
	
%	X = [X1;
%            X2,NaN(size(X2,1),1),X3];
%	Y = [Y1;
%            Y2,NaN(size(Y2,1),1),Y3];

	if (0)
		% invalidate points on mid-line downstream of bifurcation,
		% to separate the two branches
		X(n0+2:end,nn(1)+1)=NaN;
		Y(n0+2:end,nn(1)+1)=NaN;
	
		% quick fix of first grid point in bluff
		% TODO why ?
		X(n0+2,nn+1) = X(n0+1,nn+1);
		Y(n0+2,nn+1) = Y(n0+1,nn+1);
	
		% shift second grid point position
		X(n0+1,nn+1) = 0.5*(X(n0+1,nn+1) + X(n0,nn+1) );
		Y(n0+1,nn+1) = 0.5*(Y(n0+1,nn+1) + Y(n0,nn+1) );
	end

	% hierarchical mesh generation
	smesh = obj;
	for idx=0:level
		if (idx > 0)
			% leave out every second point in each dimensions
%figure(1e3)
%clf
%c={'r','g','b','m'}
			for jdx=1:4
%plot(X_C{jdx},Y_C{jdx},['o',c{jdx}],'markersize',jdx*2);
				X_C{jdx} = X_C{jdx}(1:2:end,1:2:end);
				Y_C{jdx} = Y_C{jdx}(1:2:end,1:2:end);
%				size(X_C{jdx})
%hold on
			end % for jdx
%pause
			Xs = Xs(1:2:end);
			Ys = Ys(1:2:end);
		end % if
		% concatenate
		X = [ X_C{1}, Xs, X_C{2};
		      X_C{3}, NaN(size(X_C{3},1),1), X_C{4} ];
		Y = [ Y_C{1}, Ys, Y_C{2};
		      Y_C{3}, NaN(size(X_C{3},1),1), Y_C{4} ];
		
		smesh(idx+1) = SMesh();
		smesh(idx+1).X = X;
		smesh(idx+1).Y = Y;
		smesh(idx+1).extract_elements();

	end % for level
end % generate_bifurcation


