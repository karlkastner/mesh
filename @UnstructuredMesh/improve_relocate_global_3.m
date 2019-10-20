% Sun 20 Nov 14:39:21 CET 2016
% Karl Kastner, Berlin
%
%% improve mesh quality globally
% TODO bndorder should become an object property
function obj = improve_relocate_global_3(obj,objective,opt,bndorder)
%	opt.MaxIter = 1;
%	opt.lambda = 1e7;

	XY = obj.point(:,1:2);

	% transform boundary vertices from parametric to cartesian coordinates
	XYS = obj.xy2xys(XY,bndorder);

	% solve the optimisation problem (in mixed coordinates)
	XYS = quadratic_programming(@(XYS) objective_A_bnd(obj,objective,XYS,bndorder),XYS,opt);

	% inverse transformation of boundary vertices from parametric to cartesian coordinates
	XY  = obj.xys2xy(XYS,bndorder);

	% write back
	obj.point(:,1:2) = XY;
	%obj.smooth2(nsmooth,1e-3,1e-7);
end


