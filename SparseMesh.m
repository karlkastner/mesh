% Mon 28 May 18:28:47 CEST 2018
classdef (Abstract) SparseMesh < handle
	properties
		% number of points in input vectors
		n0
		% block length
		m     = 1;
		id    = 0;
		dxmax = 20;
		% number of blocks
		n
		% delaunay triangulation
		T
		% shifted coordinate origin
		% xy0 = [0,0];
		% scale for mahalanobis distance
		S = [1];

		% vertical coordinate
		S0 = innerspace(0,1,20)';

		val;
		fdx
		mfun = @nanmedian;
	end % properties
	methods
		function obj = SparseMesh()
		end
		init(obj,X);
		obj = assign(obj,field,v0);
		meshplot(obj,field,varargin);
		[s,s2] = rmse(obj,field);
		vi = interp(obj,field,xi);
	end % methods
end % class SparseMesh

