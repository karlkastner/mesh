% Fr 29. Jan 15:01:21 CET 2016
% Karl Kastner, Berlin

function [f res f_C res_C fdx_C conde obj] = interp_fourier(obj,x0,y0,f0,tdx,m,abstol,varargin)
	% assign segments an undistributed triangle index
        % assign segments a distributed triangle index
        [fdx_C tdx_l] = obj.assign(tdx);
        f_C           = cell(1,obj.length);
        res_C         = cell(1,obj.length);
	conde         = NaN(obj.length,1);
        for idx=1:obj.length
        	[f_C{idx} res_C{idx} ~ ~ ~ ~ ~ conde(idx)] = obj.mesh_A(idx).interp_fourier( ...
                            x0(fdx_C{idx}), y0(fdx_C{idx}), f0(fdx_C{idx}), [], ...
                                              tdx_l(fdx_C{idx}),m,abstol,varargin{:});
                %[f_C{idx} res_C{idx}] = obj.mesh_A(idx).interp_fourier(x0,y0,f0,m,varargin{:});
        end % for idx
	
	% back to global coordinates
	f   = obj.local2global(f_C);
	res = obj.local2global_(res_C,fdx_C,length(f0));
end % interp_fourier

