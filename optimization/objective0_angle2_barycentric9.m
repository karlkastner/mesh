% Wed  8 Jun 11:48:27 CEST 2016
% least squares objective function of dot product and derivative in xy coordinate
function [f dfxy dfpq] = objective0_angle2_barycentric9(a,b,c,cosa0)
	ab    = (b-a);
	ac    = (c-a);
	ab2   = (ab(1,:).*ab(1,:)) + (ab(2,:).*ab(2,:)); %ab'*ab;
	ac2   = (ac(1,:).*ac(1,:)) + (ac(2,:).*ac(2,:)); %ac'*ac;
	abac  = (ab(1,:).*ac(1,:)) + (ab(2,:).*ac(2,:)); %ab'*ac;

	% dot product
	cosa  = abac ./ (sqrt(ab2.*ac2));
	f     = (cosa - cosa0).^2;

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



	ab2ac2 = ab2.*ac2;
	num = bsxfun(@times,2*(abac - sqrt(ab2ac2).*cosa0) ...
	, [	(ac2.*(abx.*ax + aby.*ay) + ab2.*(acx.*ax + acy.*ay)).*abac ...
			+ (- abx.*ax - acx.*ax - aby.*ay - acy.*ay).*ab2ac2;
		(ac2.*(abx.*bx + aby.*by) + ab2.*(acx.*bx + acy.*by)).*abac ...
			+ (- abx.*bx - acx.*bx - aby.*by - acy.*by).*ab2ac2;
		(ac2.*(abx.*cx + aby.*cy) + ab2.*(acx.*cx + acy.*cy)).*abac ...
			+ (- abx.*cx - acx.*cx - aby.*cy - acy.*cy).*ab2ac2;
		(- abx.*ax - aby.*ay).*abac + (acx.*ax + acy.*ay).*ab2;
		(- abx.*bx - aby.*by).*abac + (acx.*bx + acy.*by).*ab2;
		(- abx.*cx - aby.*cy).*abac + (acx.*cx + acy.*cy).*ab2;
		(- acx.*ax - acy.*ay).*abac + (abx.*ax + aby.*ay).*ac2;
		(- acx.*bx - acy.*by).*abac + (abx.*bx + aby.*by).*ac2;
		(- acx.*cx - acy.*cy).*abac + (abx.*cx + aby.*cy).*ac2] );
	den = [	ab2ac2.^2;
		ab2ac2.^2;
		ab2ac2.^2;
		ab2.^2.*ac2;
		ab2.^2.*ac2;
		ab2.^2.*ac2;
		ab2.*ac2.^2;
		ab2.*ac2.^2;
		ab2.*ac2.^2];
	dfpq = num./den;
if (0)
l1 = -2*(cosa0 - abac./(ab2.^(1/2).*ac2.^(1/2)));
dfpq = [ ...
l1.*((abac.*(2.*abx.*ax + 2.*aby.*ay))./(2.*ab2.^(3./2).*ac2.^(1./2)) - (abx.*ax + acx.*ax + aby.*ay + acy.*ay)./(ab2.^(1./2).*ac2.^(1./2)) + (abac.*(2.*acx.*ax + 2.*acy.*ay))./(2.*ab2.^(1./2).*ac2.^(3./2)))
l1.*((abac.*(2.*abx.*bx + 2.*aby.*by))./(2.*ab2.^(3./2).*ac2.^(1./2)) - (abx.*bx + acx.*bx + aby.*by + acy.*by)./(ab2.^(1./2).*ac2.^(1./2)) + (abac.*(2.*acx.*bx + 2.*acy.*by))./(2.*ab2.^(1./2).*ac2.^(3./2)))
l1.*((abac.*(2.*abx.*cx + 2.*aby.*cy))./(2.*ab2.^(3./2).*ac2.^(1./2)) - (abx.*cx + acx.*cx + aby.*cy + acy.*cy)./(ab2.^(1./2).*ac2.^(1./2)) + (abac.*(2.*acx.*cx + 2.*acy.*cy))./(2.*ab2.^(1./2).*ac2.^(3./2)))
l1.*((acx.*ax + acy.*ay)./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*(2.*abx.*ax + 2.*aby.*ay))./(2.*ab2.^(3./2).*ac2.^(1./2)))
l1.*((acx.*bx + acy.*by)./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*(2.*abx.*bx + 2.*aby.*by))./(2.*ab2.^(3./2).*ac2.^(1./2)))
l1.*((acx.*cx + acy.*cy)./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*(2.*abx.*cx + 2.*aby.*cy))./(2.*ab2.^(3./2).*ac2.^(1./2)))
l1.*((abx.*ax + aby.*ay)./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*(2.*acx.*ax + 2.*acy.*ay))./(2.*ab2.^(1./2).*ac2.^(3./2)))
l1.*((abx.*bx + aby.*by)./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*(2.*acx.*bx + 2.*acy.*by))./(2.*ab2.^(1./2).*ac2.^(3./2)))
l1.*((abx.*cx + aby.*cy)./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*(2.*acx.*cx + 2.*acy.*cy))./(2.*ab2.^(1./2).*ac2.^(3./2)))];
%norm(dfpq - dfpq_,1)
%norm(dfpq - dfpq_)
%norm(dfpq - dfpq_,'inf')
%norm(dfpq)
%norm(dfpq,1)
%norm(dfpq,'inf')
%pause
end
	dfxy = pq2xy9(a,b,c,dfpq);
	end % if nargout > 1
end

