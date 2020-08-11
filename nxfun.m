% Thu 19 Dec 16:00:16 +08 2019
function [n,x,a] = nxfun(L,dxl,dxr)
	%dxmax = rat*dxmin;
	% a^(n-1) = rat
	% n = 1+log(rat)/log(a)
	% sum_k=0^n-1 a^k = (1-a^n)/(1-a) 
	%                 = (1-a*rat)/(1-a)
	%                 = (1 - a*rat)/(1 - a) = L/dxmin
	%  syms a L dxmin rat; solve((1 - a*rat)/(1 - a) == L/dxmin,a)
	if (dxl == dxr)
		n = round(L/dxl)+1;
		x = linspace(0,L,n)';
		a = 1;
	else
		a = (L - dxl)/(L - dxr);
		%a = (L - dxmin)/(L - dxmin*rat);
		n = 1+log(dxr/dxl)/log(a);
		n = round(n)+1;
		if (nargout()>1)
			x = [0;cumsum(dxl*a.^(0:n-2)')];
			x = L/x(end)*x;
		end
	end
end

