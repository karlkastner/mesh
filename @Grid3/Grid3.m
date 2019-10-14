% Thu Oct 30 18:21:19 CET 2014
% Karl Kastner, Berlin

classdef Grid3 < Grid2
	properties
		X3
		dx3
		ndx3
	end % properties
	methods
	function obj = Grid3(R1, dx1, R2, dx2, R3, dx3)
		% recursively create 1D grid
		%obj = obj.grid2(R1, dx1, R2, dx2);
		obj = obj@Grid2(R1, dx1, R2, dx2);

		% number of steps
		n3 = floor((R3(2)-R3(1))/dx3)+1;

		% coorrected step with
		obj.dx3 = (R3(2)-R3(1))/(n3-1);

		% set up the T-N-Z grid
		obj.X3 = linspace(R3(1),R3(2),n3);

		% 3d-grid (z-n-t)
%		obj.XXX1 = repmat( obj.X1(:),  [1,obj.n2,n3]);
%		obj.XXX2 = repmat( obj.X2(:)', [obj.n1,1,n3]);
%		obj.XXX3 = repmat( obj.X3(:),  [obj.n1,obj.n2,1]);
	end % constructor

	function [n3 obj] = n3(obj)
		n3 = length(obj.X3);
	end
	function cX3 = cX3(obj)
		cX3 = 0.5*(obj.X3(1:end-1) + obj.X3(2:end));
	end
	function XXX1 = XXX1(obj)
		XXX1 = repmat( obj.X1(:),  [1,obj.n2,n3]);
	end
	function XXX2 = XXX2(obj)
		XXX2 = repmat( obj.X2(:)', [obj.n1,1,n3]);
	end
	function XXX3 = XXX3(obj)
		XXX3 = repmat( obj.X3(:),  [obj.n1,obj.n2,1]);
	end
	end % methods
end % classdef Grid3

