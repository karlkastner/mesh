% 2021-02-05 10:10:03.649537101 +0100
% 
% determine n, so that
% 	sum(dx0*r^k) = L
function n = smesh_stepnumber(L,dx0,r)
	if (1 == r)
		n = round(L/dx0);
	else
		n = log(1-L/dx0*(1-r))/log(r)-1;
	end
end

