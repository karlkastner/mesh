% Mon 28 May 18:28:47 CEST 2018
% Karl Kästner, Berlin
%% lump time series of sampled spatial data in one dimension (projected)
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
classdef SparseMesh1 < SparseMesh
	properties
	end % properties
	methods
		function obj = SparseMesh1(varargin)
			% default Mahalanobis weight
			obj.S = 1;
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
			plot(obj.T.x(obj.T.sdx),v(obj.T.sdx),varargin{:});
		end % meshplot

		function val = filter(obj,field,nf)
			val = obj.val.(field)(obj.T.sdx);
			fdx = isfinite(val);
			val(fdx) = medfilt1(val(fdx),nf);
			val(obj.T.sdx) = val;
			obj.val.(field) = val;
		end % filter
	end % methods
end % class SparseMesh1

