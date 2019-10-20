% 2017-08-27 12:13:44.695360405 +0200 nlogstep.m
%
% number of steps required to reach distance L with exponentially increasing step length
%
% L  : domain length
% dl : initial step length
% 
function n = nlogstep(p,L,l0);
	if (nargin()<3)
		dl = 1;
	end
	n=log(1-(1-p)*L/dl)/log(p)-1;
	%sum(p.^(0:round(n)))
end
