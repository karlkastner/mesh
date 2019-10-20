% 2016-06-07 16:36:55.769200128 +0200
%
% evaluates objective function and derivative at at [1 0 0; 0 1 0; 0 0 1]
%
% a' = p'a + q'b + (1-p'-q')c
% da = dp a + dq b + (1- dp-dq)c

function [f dfpq dfxy] = objective0_angle2_barycentric(a0,b0,c0,cosa0)
	% compute objective function and derivative in barycentric coordinates
	[f dfpq] = objective_(a0,b0,c0,cosa0);

	ax = a(1,:);
	ay = a(2,:);
	bx = b(1,:);
	by = b(2,:);
	cx = c(1,:);
	cy = c(2,:);
	ab = [bx-ax;by-ay];
	ac = [cx-ax;cy-ay];
	bc = [cx-bx;cy-by];

	cosa  = ab.'*ac / (sqrt(ab.'*ab) * sqrt(ac.'*ac));
	f = (cosa - cosa0).^2;

	abx = ab(1);
	aby = ab(2);
	ab2 = ab'*ab;
	ac2 = ac'*ac;
	acx = ac(1);
	acy = ac(2);
	bcx = bc(1);
	bcy = bc(2);
	abac = ab'*ac;
	abbc = ab'*bc;
	acbc = ac'*bc;

	if (nargout() > 1)
	df = ...
[         2*(cosa0 - (abx*acx + aby*acy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)))*(((2*acx^2 + 2*acy^2)*(abx*acx + aby*acy))/(2*(abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(3/2)) - (acx^2 + abx*acx + acy^2 + aby*acy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)) + ((abx*acx + aby*acy)*(2*abx*acx + 2*aby*acy))/(2*(abx^2 + aby^2)^(3/2)*(acx^2 + acy^2)^(1/2)))
 2*(cosa0 - (abx*acx + aby*acy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)))*(((abx*acx + aby*acy)*(2*abx*bcx + 2*aby*bcy))/(2*(abx^2 + aby^2)^(3/2)*(acx^2 + acy^2)^(1/2)) - (abx*bcx + aby*bcy + acx*bcx + acy*bcy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)) + ((abx*acx + aby*acy)*(2*acx*bcx + 2*acy*bcy))/(2*(abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(3/2)))
                                                                                                                                           2*(cosa0 - (abx*acx + aby*acy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)))*((acx^2 + acy^2)^(1/2)/(abx^2 + aby^2)^(1/2) - ((abx*acx + aby*acy)*(2*abx*acx + 2*aby*acy))/(2*(abx^2 + aby^2)^(3/2)*(acx^2 + acy^2)^(1/2)))
                                                                                                                     2*((acx*bcx + acy*bcy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)) - ((abx*acx + aby*acy)*(2*abx*bcx + 2*aby*bcy))/(2*(abx^2 + aby^2)^(3/2)*(acx^2 + acy^2)^(1/2)))*(cosa0 - (abx*acx + aby*acy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)))
                                                                                                                         2*((abx*acx + aby*acy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)) - ((2*acx^2 + 2*acy^2)*(abx*acx + aby*acy))/(2*(abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(3/2)))*(cosa0 - (abx*acx + aby*acy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)))
                                                                                                                     2*((abx*bcx + aby*bcy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)) - ((abx*acx + aby*acy)*(2*acx*bcx + 2*acy*bcy))/(2*(abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(3/2)))*(cosa0 - (abx*acx + aby*acy)/((abx^2 + aby^2)^(1/2)*(acx^2 + acy^2)^(1/2)))];
	end

	% transformation of the derivative from barycentric to cartesian coordinates
	dfxy = pq2xy([a0;b0;c0],dfpq);
end

