% Mon 21 Nov 15:15:37 CET 2016
%% for boundary points: convert XY coordinate into a 1Dparametric coordinate,
%% applied in mesh optimization, where movement of boundary points is
%% constrained on the boundary
function [XYS, obj] = xy2xys(obj,XY,order)
	bnd1 = obj.bnd1;
	nb   = length(bnd1);
	flag = false(obj.np,1);
	flag(bnd1) = true;
	switch (order)
	case {0}
		% remove boundary points
		XYS = flat(XY(~flag,:));
	case {1,2} % parametrised boundary, linear or quadratic polynomial
		XYS = [flat(XY(~flag,:)); zeros(nb,1)];
	otherwise
		error('here');
	end % xy2xys
end % xy2xys

