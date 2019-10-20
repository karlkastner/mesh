% 2016-06-07 19:00:54.373181826 +0200
%
function [f dfxy dfpq dfxy_] = objective_angle2_cartesian(a,b,c,cosa0)

	ab = b-a;
	ac = c-a;
	bc = c-b;
	ab2   = (ab(1,:).*ab(1,:)) + (ab(2,:).*ab(2,:));
	ac2   = (ac(1,:).*ac(1,:)) + (ac(2,:).*ac(2,:));
	abac  = (ab(1,:).*ac(1,:)) + (ab(2,:).*ac(2,:));

	cosa  = abac ./ (sqrt(ab2.*ac2));
	f = (cosa0 - cosa).^2;

	if (nargout() > 1)
	abx = ab(1);
	aby = ab(2);
	acx = ac(1);
	acy = ac(2);
	bcx = bc(1);
	bcy = bc(2);

	l1 = -2*(cosa0 - abac./(ab2.^(1/2).*ac2.^(1/2)));
	dfxy = ...
	[ l1.*((abac.*abx)./(ab2.^(3./2).*ac2.^(1./2)) - (abx + acx)./(ab2.^(1./2).*ac2.^(1./2)) + (abac.*acx)./(ab2.^(1./2).*ac2.^(3./2)))
	  l1.*((abac.*aby)./(ab2.^(3./2).*ac2.^(1./2)) - (aby + acy)./(ab2.^(1./2).*ac2.^(1./2)) + (abac.*acy)./(ab2.^(1./2).*ac2.^(3./2)))
                                            l1.*(acx./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*abx)./(ab2.^(3./2).*ac2.^(1./2)))
                                            l1.*(acy./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*aby)./(ab2.^(3./2).*ac2.^(1./2)))
                                            l1.*(abx./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*acx)./(ab2.^(1./2).*ac2.^(3./2)))
                                            l1.*(aby./(ab2.^(1./2).*ac2.^(1./2)) - (abac.*acy)./(ab2.^(1./2).*ac2.^(3./2)))
	];
	end % if
	if (nargout() > 2)
	ax = a(1,:);
	ay = a(2,:);
	bx = b(1,:);
	by = b(2,:);
	cx = c(1,:);
	cy = c(2,:);
	% transformation from dxy to dpq
	% by chain rule: df/dpa = dax/dpa df/dax + day/dpa df/day
	T = [(ax-cx),(ay-cy),0,0,0,0;
	     (bx-cx),(by-cy),0,0,0,0;
	     0,0,(ax-cx),(ay-cy),0,0;
	     0,0,(bx-cx),(by-cy),0,0;
	     0,0,0,0,(ax-cx),(ay-cy);
	     0,0,0,0,(bx-cx),(by-cy)];
	dfpq = T*dfxy;
	% to xy
	dfxy_ = pq2xy([a;b;c],dfpq);
	end
end

