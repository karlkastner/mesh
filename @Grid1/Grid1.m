% Sun Jan  5 18:21:14 WIB 2014
% Karl Kastner, Berlin
% 
% function obj = Grid1(R1, dx1)

classdef Grid1 < handle
	properties
		% 1d grid
		X1

		% step width
		% TODO, maybe it is better to calculate dt, dn and dz
		dx1
		R1;

		% number of source points per grid cell
		m;
		% index from source point to mesh cell
		% substructured in names, indices, reverse indices, and count
		id
		
		% value at points
		val;
		% error estimate at points
		err;
		% count of valid samples
		cnt;

		fitfun
		predfun

		% quick hack
		% depth of grid column
		%lim2;

		% indicator for valid values
		% TODO rename into mask
		valid;
	end % properties
	methods

	% constructor
	function obj = Grid1(varargin)
		for idx=1:2:length(varargin)-1
			obj.(varargin{idx}) = varargin{idx+1};
		end
	end

	function init(obj)
		dx1 = obj.dx1;
		R1  = obj.R1;
		%R1  = double(R1);
		%dx1 = double(dx1);
		% number of steps
		n1 = floor((R1(2)-R1(1))/dx1)+1;
		% exact step
		dx1 = (R1(2)-R1(1))/(n1-1);

		% set-up the grid of the first axis
		% TODO in theory, even X1 could be generated dynamically
		X1 = linspace(R1(1),R1(2),n1);

		% write back variables
		obj.dx1 = dx1;
		obj.X1  = X1;
	end % constructor

	% on demand variables to keep the memory foodprint small
	function [n1 obj] = n1(obj)
		n1 = length(obj.X1);
	end

	% centre coordinates and bin coordinates
	function cX1 = cX1(obj)
		cX1 = 0.5*(obj.X1(1:end-1) + obj.X1(2:end));
	end

	end % methods
end % class Grid1

