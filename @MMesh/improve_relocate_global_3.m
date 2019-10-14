% Sun 20 Nov 14:39:21 CET 2016
% Karl Kastner, Berlin
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

%function XYS = xy2xys(obj,XY0,XY,bndorder)
%	switch (order)
%	case {0} % constant (no movement of points at the boundary)
%		% mask boundary points
%		bnd       = flat(obj.edge(obj.bnd,:));
%		flag      = true(obj.np,1);
%		flag(bnd) = false;	
%	case {1} % linear
%	XY        = [obj.X(flag);obj.Y(flag)];
%	if (bndorder > 0)
%		XY = [XY;zeros(sum(~flag),1)];
%	end
%	end % switch order
%end % xy2xys

%function XY = xys2xy(obj,XY0,XYS,bndorder)
%	switch (order)
%	case {0}
%	case {1}
%	otherwise
%		error('not yet implemented');
%	end % switch order 
%end % xys2xy

