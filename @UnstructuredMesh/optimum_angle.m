% Fri 28 Oct 12:07:05 CEST 2016
% Karl Kastner, Berlin
%
%% optimum angle for each vertex = 360^\deg / number of connected edges
%
function [cosa0, alpha0, nn0] = optimum_angle(obj)
	% TODO the trifun only need to be explicitely evaluated for boundaries
	cosaT = Geometry.tri_angle(obj.elemX,obj.elemY);
	alphaT = acos(cosaT);

	% number of vertex neighbours
	nn     = accumarray(flat(obj.elem),ones(3*obj.nelem,1));

	% compute optimum angle
	% TODO again only needs to be expl. evaluated for bnd points, as this is simply 2pi/nn for interior points
	sum_alpha = accumarray(flat(obj.elem),alphaT(:));

	% optimum angle
	alpha0    = sum_alpha./nn;
	cosa0     = cos(alpha0);

	% optimum number of neighbours
	alpha0_ = pi/3; % 60deg
	nn0     = sum_alpha/alpha0_;
end

