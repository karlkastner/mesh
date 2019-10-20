% Thu 18 Jan 18:52:49 CET 2018
% Karl Kastner, Berlin
%% lump (fit) sampled values into the corresponding grid cell
function [obj] = fit(obj,indexfield,name,val,varargin)
%	[obj.grid_n.val.U, err.U] = obj.grid_n.binop('i1',f,time(msk),T(msk),N(msk),Z(msk),adcp.ens.velocity.cs(msk,1));
	[obj.val.(name), obj.err.(name)] = obj.binop(indexfield,obj.fitfun,val,varargin{:});
end

