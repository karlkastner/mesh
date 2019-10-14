function trimesh_fast(elem,X,Y,varargin)
	edge = [elem(:,1:2); elem(:,2:3); [elem(:,1),elem(:,3)]];
	n = size(edge,1);
	X = [X(edge),NaN(n,1)];
	Y = [Y(edge),NaN(n,1)];
	plot(flat(X'),flat(Y'),varargin{:});
end

