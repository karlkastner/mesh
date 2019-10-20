% So 29. Nov 16:23:21 CET 2015
% Karl Kastner, Berlin
%
%% split those triangles that contain a boundary point in three pieces,
%% for hierrachical mesh generation
%
function obj = split3(obj,tdx,pc,flag)
	nt            = obj.nt;
	obj.T(nt+1,:) = [obj.T(tdx,1), obj.T(tdx,2), pc];
	obj.T(nt+2,:) = [obj.T(tdx,1), pc, obj.T(tdx,3)];
	obj.T(tdx,3)  = pc;
	obj.nt        = nt+2;
	if (flag)
		% restore delaunay property by flipping
		obj.flip(obj.tdx);
		obj.flip(nt-2);
		obj.flip(nt-1);
	end

	
end

