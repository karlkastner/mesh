% Wed  8 Jun 11:48:27 CEST 2016
% least squares objective function of dot product and derivative in xy coordinate
function [f dfxy dfpq] = objective0_pythagoras2_barycentric9(a,b,c,cosa0)
	ab    = (b-a);
	ac    = (c-a);
	bc    = (c-b);
	ab2   = (ab(1,:).*ab(1,:)) + (ab(2,:).*ab(2,:));
	ac2   = (ac(1,:).*ac(1,:)) + (ac(2,:).*ac(2,:));
	bc2   = (bc(1,:).*bc(1,:)) + (bc(2,:).*bc(2,:));
	abac  = (ab(1,:).*ac(1,:)) + (ab(2,:).*ac(2,:));

	% pythagoras
	f1   = (bc2./(ab2 + ac2) - 1);
	fdx = (f1>0);
	f1(~fdx) = 0;
	f = f1.^2;

	% compute gradient
	if (nargout() > 1)

	ax = a(1,:);
	ay = a(2,:);
	bx = b(1,:);
	by = b(2,:);
	cx = c(1,:);
	cy = c(2,:);

	abx = ab(1,:);
	aby = ab(2,:);
	acx = ac(1,:);
	acy = ac(2,:);
	bcx = bc(1,:);
	bcy = bc(2,:);

	ab2ac2 = ab2.*ac2;

num = [                                       -4.*bc2.*(ab2 + ac2 - bc2).*(abx.*ax + acx.*ax + aby.*ay + acy.*ay)
                                       -4.*bc2.*(ab2 + ac2 - bc2).*(abx.*bx + acx.*bx + aby.*by + acy.*by)
                                       -4.*bc2.*(ab2 + ac2 - bc2).*(abx.*cx + acx.*cx + aby.*cy + acy.*cy)
  4.*(ab2 + ac2 - bc2).*(ab2.*ax.*bcx + abx.*ax.*bc2 + ac2.*ax.*bcx + ab2.*ay.*bcy + aby.*ay.*bc2 + ac2.*ay.*bcy)
  4.*(ab2 + ac2 - bc2).*(ab2.*bcx.*bx + abx.*bc2.*bx + ac2.*bcx.*bx + ab2.*bcy.*by + aby.*bc2.*by + ac2.*bcy.*by)
  4.*(ab2 + ac2 - bc2).*(ab2.*bcx.*cx + abx.*bc2.*cx + ac2.*bcx.*cx + ab2.*bcy.*cy + aby.*bc2.*cy + ac2.*bcy.*cy)
 -4.*(ab2 + ac2 - bc2).*(ab2.*ax.*bcx + ac2.*ax.*bcx - acx.*ax.*bc2 + ab2.*ay.*bcy + ac2.*ay.*bcy - acy.*ay.*bc2)
 -4.*(ab2 + ac2 - bc2).*(ab2.*bcx.*bx + ac2.*bcx.*bx - acx.*bc2.*bx + ab2.*bcy.*by + ac2.*bcy.*by - acy.*bc2.*by)
 -4.*(ab2 + ac2 - bc2).*(ab2.*bcx.*cx + ac2.*bcx.*cx - acx.*bc2.*cx + ab2.*bcy.*cy + ac2.*bcy.*cy - acy.*bc2.*cy) ];
 
 
den = [
  (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3 ];

	dfpq = num./den;

	dfxy = pq2xy9(a,b,c,dfpq);

	dfxy(:,~fdx) = 0;
	
	end % if nargout > 1
end

