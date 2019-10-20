% Mo 26. Okt 20:06:36 CET 2015
% Karl Kastner, Berlin
%
%% class containing some meshing functionality
%% complementary to Mesh_2d, Mesh_3d, Tree_2d and Tree_3d
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
classdef UnstructuredMesh < handle
    properties (Constant)
	left  = [3 1 2];
	right = [2 3 1];
	DELFT3D = struct('CRS',-2147483647, ...
	                 'MISVAL',-999, ...
		         'EDGETYPE', 2); % TODO should be renamed into actual type name
	MIN_NUM_BND_EDGE = 7;
	gmshopt = '-epslc1d 1e-1';
    end % properties (Constant)
    properties
        % point coordinates (X,Y,{Z})
        point = [];
	% values defined at points, e.g. pval.roughnes
	pval  = struct();
	% sn-coordinates
	S
	N
        % element indices
        elem = [];
        % edge indices
        edge  = [];
	% element indices for each edge
	edge2elem = [];
	elem2edge = [];
	elem2elem = [];
	% boundaries, index into edge
	bnd  = [];
	bnd1 = [];
	bnd3 = [];
	cid;
	weight;
	% adjacent segments, having at least one edge in common
	sneighbour = [];
	% mesh points  common with neighbours
	% col1 : local index in this segment, col 2: local index in other segment
	pinterface = {};
	l2g = [];
	% indices of ghost points
	pidghost;
	eidghost;
	%width_1d;
	%friction_1d;
	optimum_fun;
	% roughness type: {'chezy', 'manning','cd'}
	rghtype = 'chezy';
	%roughness_str = 'roughness_chezy.xyz';
    end % properties
    methods (Static)
	% this should be a constructor, but matlab allows only 1 constuctor
	[mesh sobj] = from_centreline(cS,cL,cR,cX,cY,S,np,type,sobj);
	[obj]       = raster_boundary(shp,h)
	[X Y E]     = mesh1(X,Y,h);
%	[obj] = generate_gmsh(iname,obase,resolution,scale);
%	mesh        = generate_gmsh(iname,     obase, mode, resopt, scale, minres, maxres, smoothness,linemode,mopt);
        [mesh mshname] = generate_gmsh(ifilename, obase, resolution, resfile_C, linemode, gmshopt, scale)
	[mmesh]     = generate_uniform_triangulation(arg1,arg2,x0);
	obj         = generate_from_centreline_1d(centreshp,Xc,Yc,Wc,Fc,resolution);
	[f g H]     = objective_angle(P,elem,bnd3);
        XY          = restore_acuteness(elem,XY,XY0,verbose);
        g           = project_to_boundary(g,XY,bnd3,order);
	obj 	    = generate_uniform_tetra(varargin);
    end

    methods
        % constructor
        function obj = UnstructuredMesh(varargin)
	    if (nargin() > 0)
                obj.point = varargin{1};
	    end
            if (nargin() > 1)
                obj.elem  = varargin{2};
	    end
	    if (nargin() > 2)
                %obj.elem4 = elem4;
                obj.edge  = varargin{3};
            end
        end % constructor
	function [elem fdx obj] = elemN(obj,N)
		elem = obj.elem;
		fdx = obj.ngon(N);
		if (isempty(fdx))
			elem = [];
		else
			elem = elem(fdx,1:N);	
		end
	end
	% select n-gone
	% classify elements by number of nodes, e.g triangles, quadrilaterals, pentagons, hexagons, etc.
	function [fdx obj]  = ngon(obj,n)
		elem  = obj.elem;
		nnode = sum( (elem ~= -2147483647 & elem ~= 0 & isfinite(elem)), 2);
		fdx = find(nnode == n);
	end
	%
	% pseudo members
	%
	function [np obj] = np(obj)
		np = size(obj.point,1);
	end
	function [ne obj] = nelem(obj)
		ne = size(obj.elem,1);
	end
	function [ne obj] = nedge(obj)
		ne = size(obj.edge,1);
	end
	function [X obj] = X(obj,fdx)
		if (nargin > 1)
			if (islogical(fdx))
				X = obj.point(fdx,1);
			else
				X = NaN(prod(size(fdx)),1);
				flag = (fdx>0);
				X(flag) = obj.point(fdx(flag),1);
			end
		else
			X = obj.point(:,1);
		end
	end
	function [Y obj] = Y(obj,fdx)
		if (nargin > 1)
			if (islogical(fdx))
				Y = obj.point(fdx,2);
			else
				Y       = NaN(prod(size(fdx)),1);
				flag    = (fdx>0);
				Y(flag) = obj.point(fdx(flag),2);
			end
		else
			Y = obj.point(:,2);
		end
	end
	function [Z obj] = Z(obj,fdx)
		if (size(obj.point,2) < 3)
			Z = [];
		else
		if (nargin > 1)
			if (islogical(fdx))
				Z = obj.point(fdx,3);
			else
				Z    = NaN(prod(size(fdx)),1);
				flag = (fdx>0);
				Z(flag) = obj.point(fdx(flag),3);
			end
		else
			Z = obj.point(:,3);
		end
		end
	end
	function [X obj] = edgeX(obj)
		X = obj.point(obj.edge);
		X = reshape(X,[],2);
		%X = [P(E(:,1),1) P(E(:,2),1)];
	end
	
	function [Y obj] = edgeY(obj)
		Y = obj.point(obj.edge);
		Y = reshape(Y,[],2);
		%Y = [P(E(:,1),2) P(E(:,2),2)];
	end
	function [X obj] = elemX(obj,fdx)
		if (nargin() < 2)
			X = reshape(obj.X(obj.elem),[],size(obj.elem,2));
		else
			X = reshape(obj.X(obj.elem(fdx,:)),[],size(obj.elem,2));
		end
	end
	function [Z obj] = elemZ(obj,fdx)
		if (size(obj.point,2) < 3)
			Z = []
		else
		if (nargin() < 2)
			Z = reshape(obj.Z(obj.elem),[],size(obj.elem,2));
		else
			Z = reshape(obj.Z(obj.elem(fdx,:)),[],size(obj.elem,2));
		end
		end % else
	end % elemZ
	function [Y obj] = elemY(obj, fdx)
		if (nargin() < 2)
			Y = reshape(obj.Y(obj.elem),[],size(obj.elem,2));
		else
			Y = reshape(obj.Y(obj.elem(fdx,:)),[],size(obj.elem,2));
		end
	end

	% for backward compatibility
	function [T obj] = T(obj)
		T = obj.elem;
	end
	function [elem obj] = elem_global(obj)
		elem = obj.l2g(obj.elem);
	end
	function [n obj] = nbnd(obj)
		n = length(obj.bnd);
	end
	function [pn obj] = pneighbour(obj)
		if (0 == obj.nedge)
			obj.edges_from_elements();
		end
		pn = cell(obj.np,1);
		for idx=1:obj.nedge
			pn{obj.edge(idx,1)} = [pn{obj.edge(idx,1)}, obj.edge(idx,2)];
			pn{obj.edge(idx,2)} = [pn{obj.edge(idx,2)}, obj.edge(idx,1)];
		end
		if (DEBUG.level > 0)
			for idx=1:obj.np
				if (max(pn{idx}) > obj.np)
					error('here');
				end
			end
		end
	end % pneighbour
    end % methods
end % class Mesh

