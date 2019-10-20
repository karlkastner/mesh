
%% interpolation part of the error : 
%% e ~ 1/2*d^2v/dx^2 * dx^2 + higher order terms
%%   ~ 1/2*d^2 v
%% the other part of the error is the sampling error (gaussian noise)
%% 
%% the mesh is optimal, when e_nois ~ e_interp
%%
function [s,s2] = rmse_interp(obj,field)
	v  = obj.val.(field)(obj.T.sdx);
	 %obj.val.(field)(obj.T.ConnectivityList(:,:));
	d2v = 1/2*cdiff(v,2);
	se_interp = rms(d2v);
	%s2 = mean(dv.^2);
	%s2 = var(v.');
	%s  = sqrt(mean(s2));
end

