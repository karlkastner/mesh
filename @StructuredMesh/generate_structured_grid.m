% Mo 28. Sep 14:16:30 CEST 2015
% Karl Kastner, Berlin
%% generate a structured mesh consisting of several sub-meshes
% note : the generated grid is not orthogonal
% TODO, convert to shp point, grd
% TODO, put elements, points and coordinates (mesh output)

function [X, Y, E, C, BC, obj] = generate_structured_grid(obj)
	dmin = 1;

	% input : map input coordinates to the unit square (for numerical stability)
	% TODO
	
	% generate row and column indices
	BC = obj.bc_index(obj.BC);
	
	% for each block
	BC(1).X = []; BC(1).Y = [];
	BC(1).E = []; BC(1).C = [];
	for bdx=1:length(BC)
		BC(bdx) = obj.grid_block(BC(bdx));
	end % for bdx (each block)

%	L = zeros(length(BC));
%	c = zeros(length(BC));
	% stitch blocks
	open = [1];
	connected = false(length(BC),1);
	while (~isempty(open))
		idx = open(end);
		open(end) = [];
		% do not process twice
%		if (~connected(idx))
%			connected(idx) = true;

		% for each direction
		jdx = BC(idx).north.link;
		if (jdx > 0 && ~connected(jdx))
			open(end+1) = jdx;
			connected(jdx) = true;
			% stack columns vertically above block i
			BC(jdx).E = BC(jdx).E + BC(idx).E(end,end);
			BC(jdx).C = BC(jdx).C + BC(idx).C(1,1) - 1;
		end
		jdx = BC(idx).east.link;
		if (jdx > 0 && ~connected(jdx))
			open(end+1) = jdx;
			connected(jdx) = true;
			BC(jdx).C = BC(jdx).C + BC(idx).C(end,end);
			BC(jdx).E = BC(jdx).E + BC(idx).E(1,1) - 1;
		end
		jdx = BC(idx).south.link;
		if (jdx > 0 && ~connected(jdx))
			open(end+1) = jdx;
			connected(jdx) = true;
			BC(jdx).E = BC(jdx).E - BC(jdx).E(end,end) + BC(idx).E(1,1) - 1;
			BC(jdx).C = BC(jdx).C + BC(idx).C(1,1) - 1;
		end
		jdx = BC(idx).west.link;
		if (jdx > 0 && ~connected(jdx))
			open(end+1) = jdx;
			connected(jdx) = true;
			BC(jdx).C = BC(jdx).C - BC(jdx).C(end,end) + BC(idx).C(1,1) - 1;
			BC(jdx).E = BC(jdx).E + BC(idx).E(1,1) - 1;
		end
%		end % if not yet connecteed
	end % while there are open

	% TODO, first row needs to be clipped to avoid duplicates

	if (sum(~connected) > 0)
		error('some blocks are not connected to block 1');
	end
		
	% TODO, check that all are (at least indirectly) linked to block 1

	% set up global matrix
	E = [];
	C = [];
	X = [];
	Y = [];
	for idx=1:length(BC)
		E = [E; flat(BC(idx).E)];
		C = [C; flat(BC(idx).C)];
		X = [X; flat(BC(idx).X)];
		Y = [Y; flat(BC(idx).Y)];
	end
	E = E - min(E) + 1;
	C = C - min(C) + 1;
		
	% test for uniqueness
	if (length(unique([E C],'rows')) ~= size(E,1) )
		error('Duplicate row/column indices')
	end
	% fix zero invalid value
	X(X==0) = sqrt(eps);
	Y(Y==0) = sqrt(eps);

	X = sparse(E,C,X);
	Y = sparse(E,C,Y);
	
	% resolve identical grid points
	% TODO, quick hack
%	fdx = find(diff(X)==0 & diff(Y) == 0 & (X(1:end-1,:) ~= 0));
%	X(fdx) = X(fdx) - pi;
%	Y(fdx) = Y(fdx) - pi;

%	fdx = find( (diff(X')'==0 & diff(Y')' == 0 & (X(:,1:end-1)~=0)));
%	X(fdx) = X(fdx) - pi;
%	Y(fdx) = Y(fdx) - pi;

	for idx=2:size(X,1)-1
	for jdx=2:size(X,2)-1
		if (X(idx,jdx) ~= 0 & X(idx,jdx) == X(idx-1,jdx) && Y(idx,jdx) == Y(idx-1,jdx))
			X(idx,jdx) = X(idx,jdx) + dmin;	
			Y(idx,jdx) = Y(idx,jdx) + dmin;	
		end
		if (X(idx,jdx) ~= 0 & X(idx,jdx) == X(idx,jdx-1) && Y(idx,jdx) == Y(idx,jdx-1))
			X(idx,jdx) = X(idx,jdx) + dmin;	
			Y(idx,jdx) = Y(idx,jdx) + dmin;	
		end
	end
	end

	% TODO global optimisation

	obj.X = X;
	obj.Y = Y;
	obj.E = E;
	obj.C = C;
	obj.BC = BC;

	obj.extract_elements();

end % function


