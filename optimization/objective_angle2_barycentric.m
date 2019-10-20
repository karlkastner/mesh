% 2016-06-07 19:40:48.599166205 +0200

function [f] = objective_angle2_barycentric(pqa,pqb,pqc,a0,b0,c0,cosa0)
	% transform from barycentric to cartesian
	a = pqa(1)*a0 + pqa(2)*b0 + (1-pqa(1)-pqa(2))*c0;
	b = pqb(1)*a0 + pqb(2)*b0 + (1-pqb(1)-pqb(2))*c0;
	c = pqc(1)*a0 + pqc(2)*b0 + (1-pqc(1)-pqc(2))*c0;
	
	% compute objective function and derivative in barycentric coordinates
	[f] = objective0_angle2_barycentric(a,b,c,cosa0);
end

