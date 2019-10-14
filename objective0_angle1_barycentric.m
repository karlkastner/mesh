% Sun 12 Jun 12:13:55 CEST 2016
% Karl Kastner, Berlin
function [f dfxy dfpq] = objective_angle1_barycentric(a,b,c,cosa0)
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

	num = [ ...
	(- ac2.*(abx.*ax + aby.*ay) - ab2.*(acx.*ax + acy.*ay)).*abac + ab2.*ac2.*(abx.*ax + acx.*ax + aby.*ay + acy.*ay);
	(- ac2.*(abx.*bx + aby.*by) - ab2.*(acx.*bx + acy.*by)).*abac + ab2.*ac2.*(abx.*bx + acx.*bx + aby.*by + acy.*by);
	(- ac2.*(abx.*cx + aby.*cy) - ab2.*(acx.*cx + acy.*cy)).*abac + ab2.*ac2.*(abx.*cx + acx.*cx + aby.*cy + acy.*cy);
                                                     (abx.*ax + aby.*ay).*abac + (- acx.*ax - acy.*ay).*ab2;
                                                     (abx.*bx + aby.*by).*abac + (- acx.*bx - acy.*by).*ab2;
                                                     (abx.*cx + aby.*cy).*abac + (- acx.*cx - acy.*cy).*ab2;
                                                     (acx.*ax + acy.*ay).*abac + (- abx.*ax - aby.*ay).*ac2;
                                                     (acx.*bx + acy.*by).*abac + (- abx.*bx - aby.*by).*ac2;
                                                     (acx.*cx + acy.*cy).*abac + (- abx.*cx - aby.*cy).*ac2 ];
  	den = [  ab2.^(3/2).*ac2.^(3/2);
		 ab2.^(3/2).*ac2.^(3/2);
		 ab2.^(3/2).*ac2.^(3/2);
		 ab2.^(3/2).*ac2.^(1/2);
		 ab2.^(3/2).*ac2.^(1/2);
		 ab2.^(3/2).*ac2.^(1/2);
		 ab2.^(1/2).*ac2.^(3/2);
		 ab2.^(1/2).*ac2.^(3/2);
		 ab2.^(1/2).*ac2.^(3/2)];

	dfxy = num./den;

	dfxy(:,~fdx) = 0;
	end
end 

