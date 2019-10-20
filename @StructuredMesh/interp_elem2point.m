% 2018-11-22 17:30:48.906160381 +0800
%% interpolate values sampled at element centres to element corners
%% TODO allow also interpolation to u and v points
function Z = interp_elem2point(obj,Z)
	n = obj.n;
	Z = interp1((1:n(1)-1)/n(1),Z,(0:n(1)-1)/(n(1)-1),'linear','extrap');
	Z = interp1((1:n(2)-1)/n(1),Z',(0:n(2)-1)/(n(1)-1),'linear','extrap')';
end

