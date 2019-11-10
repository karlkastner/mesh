% Sat 26 May 13:38:59 CEST 2018
% Karl Kästner, Berlin
%% lump time series of sampled spatial data (track recordings) along two dimensions,
%% e.g 1 projected spatial dimension and one for time time
%% TODO : better blocks (all neighbours within mahalanobis distance)
%% TODO : do not use simple mean, but allow for least squares regression
%% TODO : precompute the least squares weights for accummarray
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
classdef SparseMesh2 < SparseMesh
	properties
	end % properties
	methods
		function obj = SparseMesh2(varargin)
			% default Mahalanobis weight
			obj.S = [1,1];
			for idx=1:2:length(varargin)-1
				obj.(varargin{idx}) = varargin{idx+1};
			end % for idx
		end % constructor

		function meshplot(obj,field,varargin)
			%trimesh(obj.T.ConnectivityList,obj.T.Points(:,1),obj.T.Points(:,2),[],obj.val.(field));
			if (isstr(field))
				v  = obj.val.(field);
			else
				v = field;
			end
			trisurf(obj.T.ConnectivityList, ...
				obj.T.Points(:,1),obj.T.Points(:,2),[],v, ...
				'edgecolor','none', varargin{:});
			view(0,90);
		end % meshplot

	end % methods
end % class SparseMesh2

