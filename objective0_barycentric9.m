% 2016-06-08 11:47:48.501970505 +0200
function [f] = objective_angle2_barycentric9(pqa,pqb,pqc,a0,b0,c0,cosa0)
	% transform from barycentric to cartesian
	a = pqa(1)*a0 + pqa(2)*b0 + (pqa(3))*c0;
	b = pqb(1)*a0 + pqb(2)*b0 + (pqb(3))*c0;
	c = pqc(1)*a0 + pqc(2)*b0 + (pqc(3))*c0;

	% compute objective function and derivative in barycentric coordinates
	[f] = objective0_angle2_barycentric(a,b,c,cosa0);
end

