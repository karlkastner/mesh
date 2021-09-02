% 2021-05-23 17:58:10.545938433 +0200
% determine a and n so that
% d	xl*a^n = dxr
% and
% 	sum_{k=1}^n dxl*a^k = L
function [a,n]=dxlr2ak(dxl,dxr,L)
	k = L/sqrt(dxl*dxr);
	a = (dxr/dxl)^(1/k);
	%a = dxr/dxl;
	a = lsqnonlin(@(a) fun(a)-L,a);	
	n = log(dxr/dxl)/log(a);

	function L_ = fun(a)
		n  = log(dxr/dxl)/log(a);
		L_ = dxl*(1-a.^(n+1))./(1-a);
	end
end


