% Mon 28 May 18:28:47 CEST 2018
% Karl Kastner, Berlin
%% SparseMesh superclass
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
		% elements (segments for 1d and triangles for 2d)
		T
		% T.sdx : index, into segment, into which each sample belongs
		% T.x   : centre coordinate of each segment
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

