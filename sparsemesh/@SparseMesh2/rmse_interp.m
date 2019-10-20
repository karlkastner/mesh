% Sat 26 May 13:38:59 CEST 2018
% Karl Kästner, Berlin
%% interpolation part of the error : 
%% e ~ 1/2*d^2v/dx^2 * dx^2 + higher order terms
%%   ~ 1/2*d^2 v
%% the other part of the error is the sampling error (gaussian noise)
%% 
%% the mesh is optimal, when e_nois ~ e_interp
%%
%% TODO this is e ~ f', not f''
function [s,s2]  = rmse_interp(obj,field)
	v  = obj.val.(field)(obj.T.ConnectivityList(:,:));
	s2 = var(v.');
	s  = sqrt(mean(s2));
end

