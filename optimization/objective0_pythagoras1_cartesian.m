% Sun 12 Jun 12:13:55 CEST 2016
% Karl Kastner, Berlin

% TODO scale factor:
% min	max( (s*c^2/(a^2+b^2)) - 1, 0)
%s = 2 : equilateral
%s = 1 : right
function [f dfxy dfpq] = objective_angle1_euclidean(a,b,c,cosa0)
	ab    = (b-a);
	ac    = (c-a);
	bc    = (c-b);
	ab2   = (ab(1,:).*ab(1,:)) + (ab(2,:).*ab(2,:));
	ac2   = (ac(1,:).*ac(1,:)) + (ac(2,:).*ac(2,:));
	bc2   = (bc(1,:).*bc(1,:)) + (bc(2,:).*bc(2,:));
	abac  = (ab(1,:).*ac(1,:)) + (ab(2,:).*ac(2,:));

%	% dot product
%	cosa  = abac ./ (sqrt(ab2.*ac2));
%	f     = (cosa0 - cosa);


	% pythagoras
	f = (bc2./(ab2 + ac2) - 1);
	
	f   = max(0,f);
	fdx = f>0;

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

num = [            2.*bc2.*(abx + acx)
                   2.*bc2.*(aby + acy)
 - 2.*ab2.*bcx - 2.*abx.*bc2 - 2.*ac2.*bcx
 - 2.*ab2.*bcy - 2.*aby.*bc2 - 2.*ac2.*bcy
   2.*ab2.*bcx + 2.*ac2.*bcx - 2.*acx.*bc2
   2.*ab2.*bcy + 2.*ac2.*bcy - 2.*acy.*bc2 ];
den = [
 (ab2 + ac2).^2;
 (ab2 + ac2).^2;
 (ab2 + ac2).^2;
 (ab2 + ac2).^2;
 (ab2 + ac2).^2;
 (ab2 + ac2).^2 ];

	dfxy = num./den;

	dfxy(:,~fdx) = 0;
	end
end 

