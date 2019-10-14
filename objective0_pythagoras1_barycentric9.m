% Wed  8 Jun 11:48:27 CEST 2016
% least squares objective function of dot product and derivative in xy coordinate
function [f dfxy dfpq] = objective0_pythagoras1_barycentric9(a,b,c,cosa0)
	ab    = (b-a);
	ac    = (c-a);
	bc    = (c-b);
	ab2   = (ab(1,:).*ab(1,:)) + (ab(2,:).*ab(2,:));
	ac2   = (ac(1,:).*ac(1,:)) + (ac(2,:).*ac(2,:));
	bc2   = (bc(1,:).*bc(1,:)) + (bc(2,:).*bc(2,:));
	abac  = (ab(1,:).*ac(1,:)) + (ab(2,:).*ac(2,:));

	% pythagoras
	f   = (bc2./(ab2 + ac2) - 1);
	fdx = (f>0);
	f(~fdx) = 0;

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

num = [                                          2.*bc2.*(abx.*ax + acx.*ax + aby.*ay + acy.*ay)
                                                 2.*bc2.*(abx.*bx + acx.*bx + aby.*by + acy.*by)
                                                 2.*bc2.*(abx.*cx + acx.*cx + aby.*cy + acy.*cy)
 - 2.*ab2.*ax.*bcx - 2.*abx.*ax.*bc2 - 2.*ac2.*ax.*bcx - 2.*ab2.*ay.*bcy - 2.*aby.*ay.*bc2 - 2.*ac2.*ay.*bcy
 - 2.*ab2.*bcx.*bx - 2.*abx.*bc2.*bx - 2.*ac2.*bcx.*bx - 2.*ab2.*bcy.*by - 2.*aby.*bc2.*by - 2.*ac2.*bcy.*by
 - 2.*ab2.*bcx.*cx - 2.*abx.*bc2.*cx - 2.*ac2.*bcx.*cx - 2.*ab2.*bcy.*cy - 2.*aby.*bc2.*cy - 2.*ac2.*bcy.*cy
   2.*ab2.*ax.*bcx + 2.*ac2.*ax.*bcx - 2.*acx.*ax.*bc2 + 2.*ab2.*ay.*bcy + 2.*ac2.*ay.*bcy - 2.*acy.*ay.*bc2
   2.*ab2.*bcx.*bx + 2.*ac2.*bcx.*bx - 2.*acx.*bc2.*bx + 2.*ab2.*bcy.*by + 2.*ac2.*bcy.*by - 2.*acy.*bc2.*by
   2.*ab2.*bcx.*cx + 2.*ac2.*bcx.*cx - 2.*acx.*bc2.*cx + 2.*ab2.*bcy.*cy + 2.*ac2.*bcy.*cy - 2.*acy.*bc2.*cy ];
den = [
  (ab2 + ac2).^2
 (ab2 + ac2).^2
 (ab2 + ac2).^2
 (ab2 + ac2).^2
 (ab2 + ac2).^2
 (ab2 + ac2).^2
 (ab2 + ac2).^2
 (ab2 + ac2).^2
 (ab2 + ac2).^2 ];
	dfpq = num./den;

	dfxy = pq2xy9(a,b,c,dfpq);

	dfxy(:,~fdx) = 0;
	
	end % if nargout > 1
end

