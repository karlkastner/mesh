% Wed  8 Jun 11:48:27 CEST 2016
% least squares objective function of dot product and derivative in xy coordinate
function [f dfxy dfpq] = objective0_pythagoras2_cartesian(a,b,c,cosa0)
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

	num = [-4.*bc2.*(abx + acx).*(ab2 + ac2 - bc2)
               -4.*bc2.*(aby + acy).*(ab2 + ac2 - bc2)
  4.*(ab2.*bcx + abx.*bc2 + ac2.*bcx).*(ab2 + ac2 - bc2)
  4.*(ab2.*bcy + aby.*bc2 + ac2.*bcy).*(ab2 + ac2 - bc2)
 -4.*(ab2.*bcx + ac2.*bcx - acx.*bc2).*(ab2 + ac2 - bc2)
 -4.*(ab2.*bcy + ac2.*bcy - acy.*bc2).*(ab2 + ac2 - bc2)];
 
 den = [
  (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3
 (ab2 + ac2).^3 ];


	dfxy = num./den;

	dfxy(:,~fdx) = 0;
	
	end % if nargout > 1
end

