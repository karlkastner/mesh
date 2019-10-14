% Thu Oct 30 18:22:15 CET 2014
% Karl Kastner, Berlin

classdef Grid2 < Grid1
	properties
		X2
		dx2
		ndx1
		ndx2
		mask;
		R2
		% QUICK fix
		eid;
	end % properties

	methods
	function obj = Grid2(varargin)
		for idx=1:2:length(varargin)-1
			obj.(varargin{idx}) = varargin{idx+1};
		end
	end
	
	function obj = init(obj)
		% recursively create 1D grid
		%obj@Grid1.init();
		obj.init@Grid1();
		%obj = obj@Grid1(R1, dx1);
		%R1 = obj.R1;
		dx2 = obj.dx2;
		R2 = obj.R2;
		%R1, dx1, R2, dx2)

		R2  = double(R2);
		dx2 = double(dx2);


		% number of steps
		n2 = floor((R2(2)-R2(1))/dx2)+1;
		% exact step width
		dx2 = (R2(2)-R2(1))/(n2-1);

		% set up the grid of the second axis
		X2 = linspace(R2(1),R2(2),n2);

		% write back variables
		obj.dx2 = dx2;
		obj.X2  = X2;
%		obj.XX1 = XX1;
%		obj.XX2 = XX2;
	end % constructor

	function [n2 obj] = n2(obj)
		n2 = length(obj.X2);
	end
	function cX2 = cX2(obj)
		cX2 = 0.5*(obj.X2(1:end-1) + obj.X2(2:end));
	end
	function cXX1 = cXX1(obj)
		cX1 = obj.cX1;
		cXX1 = repmat(cX1(:),1,obj.n2-1);
	end
	function cXX2 = cXX2(obj)
		cX2 = obj.cX2;
		cXX2 = repmat(cX2(:)',obj.n1-1,1);
	end
	function XX1 = XX1(obj)
		XX1 = repmat(obj.X1(:),       1, obj.n2);
	end
	function XX2 = XX2(obj)
		XX2 = repmat(obj.X2(:)', obj.n1,      1);	
	end
	end % methods
end % classdef Grid2


