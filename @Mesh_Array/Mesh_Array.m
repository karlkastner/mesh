% Mi 27. Jan 11:52:35 CET 2016
% Karl Kastner, Berlin 

%- centreline generator along max
% princinpal vector in n direction : arnoldi with startvector, which is orthogonal to the two principal eigenvector and has a gradient everywhere orthogonal to them
classdef Mesh_Array < handle
    properties
        % array of MMesh
        mesh_A = [];
        % segment index each element (triangle) of the unsegmented mesh is assigned to
        tsdx   = [];
        % global to segment internal triangle index
        tdx_g2l = [];
%	pdx_l2g = {};
    end
    methods
        % constructor
        function obj = Mesh_Array(varargin)
            if (nargin() > 0)
            switch(class(varargin{1}))
	    case {'Structured_Mesh'}
		obj.mesh_A = horzcat(varargin{});
            case {'MMesh'}
                obj.mesh_A = horzcat(varargin{:});
            case {'Mesh_Array'}
                %mat = cell2mat(varargin);
                for idx=1:length(varargin)
                    %obj.mesh_A = horzcat(mat.mesh_A);
                    obj.mesh_A = [obj.mesh_A, varargin{idx}.mesh_A];
                end
            otherwise
                st = dbstack;
                error(st.name,'Constructor');
            end
            end % if nargin > 0
        end
%        function [mesh_A obj] = subsref(obj,sub)
%            mesh_A = obj.mesh_A(sub(2).subs);
%        end
        function obj = plot(obj,val_C,opt)
            if (nargin() < 3 || isempty(opt))
                opt.surfarg = {'EdgeColor','none'};
            end
            ih = ishold;
            for idx=1:obj.length
                if (nargin < 2 || isempty(val_C))
                    % colour each segment differently
		    val = idx*ones(obj.mesh_A(idx).np,1);
                    obj.mesh_A(idx).plot(val,opt);
                else
                    obj.mesh_A(idx).plot(val_C{idx},opt);
                end
                hold on;
            end
            if (~ih)
                hold off;
            end
        end
        function [fdx_C tdx_l obj] = assign(obj,tdx_g)
            fdx_C = cell(1,obj.length);
            % tdx_C = cell(1,obj.length);
            % segment each triangle belongs to
	    % sdx is zero based
	    sdx = zeros(size(tdx_g));
	    fdx = tdx_g > 0;
            sdx(fdx) = obj.tsdx(tdx_g(fdx));
            for idx=1:obj.length
                % all samples belonging to current segment
                fdx_C{idx} = find(idx == sdx);
                % global to local index
                tdx_l(fdx_C{idx}) = obj.tdx_g2l(tdx_g(fdx_C{idx}));
            end % for idx
        end % assing
        function [leng obj] = length(obj)
            leng = length(obj.mesh_A);
        end
	function [np obj] = np(obj)
		np = 0;
		for idx=1:obj.length
			np = max(np,obj.mesh_A(idx).np);
		end
	end
	function [f obj] = local2global(obj,f_C)
		f = NaN(obj.np,1);
		for idx=1:obj.length
			f(obj.mesh_A(idx).l2g) = f_C{idx};
		end % for idx
	end % local2global
	% this is for points not coinciding with mesh points, e.g. the residual
	function [f obj] = local2global_(obj,f_C,fdx_C,n)
		f = NaN(n,1);
		for idx=1:length(f_C)
			f(fdx_C{idx}) = f_C{idx};
		end
	end
    end %
end % Mesh_Array

