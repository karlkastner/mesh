% Sun 12 Jun 12:13:55 CEST 2016
% Karl Kastner, Berlin

% max angle
function [f dfxy dfpq] = objective_angle1_cartesian(a,b,c,cosa0)
	ab    = (b-a);
	ac    = (c-a);
	ab2   = (ab(1,:).*ab(1,:)) + (ab(2,:).*ab(2,:));
	ac2   = (ac(1,:).*ac(1,:)) + (ac(2,:).*ac(2,:));
	abac  = (ab(1,:).*ac(1,:)) + (ab(2,:).*ac(2,:));

	% dot product
	cosa  = abac ./ (sqrt(ab2.*ac2));
	f     = (cosa0 - cosa);
	
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

	num = [  ab2.*abx.*ac2 - ab2.*abac.*acx - abac.*abx.*ac2 + ab2.*ac2.*acx;
		 ab2.*aby.*ac2 - ab2.*abac.*acy - abac.*aby.*ac2 + ab2.*ac2.*acy;
                                      abac.*abx - ab2.*acx;
                                      abac.*aby - ab2.*acy;
                                      abac.*acx - abx.*ac2;
                                      abac.*acy - aby.*ac2];
 	den = [ ab2.^(3/2).*ac2.^(3/2)
		 ab2.^(3/2).*ac2.^(3/2)
		 ab2.^(3/2).*ac2.^(1/2)
		 ab2.^(3/2).*ac2.^(1/2)
		 ab2.^(1/2).*ac2.^(3/2)
		 ab2.^(1/2).*ac2.^(3/2) ];

	dfxy = num./den;

	dfxy(:,~fdx) = 0;
	end
end 

