% Mon 26 Nov 19:45:46 CET 2018
% hierarchical mesh generation

% TODO, spine with kid has to be kept (!)

function smesh = child(obj,level, kid)
	if (nargin() < 1)
		level = 1;
	end
	if (level > 0)
	smesh = SMesh(); % .empty(0);
	
	% leave out every second point in each dimensions
	for jdx=1:4
		X_C{jdx} = X_C{jdx}(1:2:end,1:2:end);
		Y_C{jdx} = Y_C{jdx}(1:2:end,1:2:end);
	end % for jdx

	Xs = Xs(1:2:end);
	Ys = Ys(1:2:end);
	
	% concatenate
	X = [ X_C{1}, Xs, X_C{2};
	      X_C{3}, NaN(size(X_C{3},1),1), X_C{4} ];
	Y = [ Y_C{1}, Ys, Y_C{2};
	      Y_C{3}, NaN(size(X_C{3},1),1), Y_C{4} ];
	
	smesh = SMesh();
	smesh.X = X;
	smesh.Y = Y;
	smesh.extract_elements();
	
	end
end % child

