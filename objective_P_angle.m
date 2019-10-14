% 2016-09-26 01:24:02 +0200 objective_angle_scaled
% Karl Kastner, Berlin
%
% objective_P_angle : point based objective function value
% this does not seem to work well
%
% E   : set of triangle point indices
% P   : point coordinates
% bnd : boundaries [pdx, left, right]
%
% TODO return box constraints of point movements (not beyond midpoints of adjoining edges)
% TODO pass norm
function [f g c H g_] = objective_angle(E,P,bnd)
	nT = size(E,1);
	nP = size(P,1);
	X = P(:,1);
	Y = P(:,2);
	
	% coordinates of triangle points
	XT = X(E);
	YT = Y(E);
	if (1==size(E,1))
		XT = rvec(XT);
		YT = rvec(YT);
	end

	% interior angles of triangles
	% TODO the trifun only need to be explicitely evaluated for boundaries
	cosaT = Geometry.tri_angle(XT,YT);
	alphaT = acos(cosaT);

	% number of vertex neighbours
	nn     = accumarray(E(:),ones(3*nT,1));

	% compute optimum angle
	% TODO again only needs to be expl. evaluated for bnd points, as this is simply 2pi/nn for interior points
	alpha0 = accumarray(E(:),alphaT(:))./nn;
	cosa0   = cos(alpha0);
	%alpha0 = 1/3*pi*ones(size(alpha0));

	dx = right(XT)-left(XT);
	dy = right(YT)-left(YT);
	l2 = dx.^2 + dy.^2;
	scale = sum(l2,2);

% TODO do not choose max angle but max function value!!!

	% compute maximum angle
	mid   = accumarray(E(:),(1:3*nT)',[],@(id) maxid(alphaT(:),id));
	midT  = mod(mid-1,nT)+1;
	midC  = idivide(int32(mid-1),int32(nT))+1;
	alpha = alphaT(mid);
	if (1==size(E,1))
		alpha=cvec(alpha);
	end

	% compute objective function value
	f = (alpha-alpha0).^2;
	f = f.*scale;
	f = f';

	% fore each point fetch the triangle with maximum angle
	E_ = E(midT,:);

	% reorder the points, such that the index of the each point comes first
	for idx=1:nP
		E_(idx,:) = circshift(E_(idx,:),[0, -(midC(idx)-1)]);
	end

	% test
	if (norm(E_(:,1)-(1:nP)','inf')>0)
		error('here');
	end
	if (nargout() > 1)
	% compute the gradient
	XT = X(E_);
	YT = Y(E_);

	ax = XT(:,1);
	bx = XT(:,2);
	cx = XT(:,3);
	ay = YT(:,1);
	by = YT(:,2);
	cy = YT(:,3);
	abx = bx-ax;
	aby = by-ay;
	acx = cx-ax;
	acy = cy-ay;
	bcx = cx-bx;
	bcy = cy-by;
	ab2 = abx.^2 + aby.^2;
	ac2 = acx.^2 + acy.^2;
	abac = (abx.*acx + aby.*acy);
%	cab = abx*acy-aby*acx;
	cab = ax.*by - ay.*bx;
	cac = ax.*cy - ay.*cy;
	cbc = bx.*cy - by.*cx;

rad = 0;
gx = zeros(nP,1);
gy = zeros(nP,1);
if (rad)	
	g = NaN;
else
	gx = accumarray(E_(:),	 [...
 -(2.*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*((bx - 2.*ax + cx)./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)) + (((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).*(2.*ax - 2.*bx))./(2.*((ax - bx).^2 + (ay - by).^2).^(3./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)) + (((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).*(2.*ax - 2.*cx))./(2.*((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(3./2))))./(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2);
                                                                                                                                                                                                                                       (2.*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*(ay - by).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(((ax - bx).^2 + (ay - by).^2).^(3./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2).*(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2));
                                                                                                                                                                                                                                      -(2.*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*(ay - cy).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(3./2).*(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2))]);
	gy = accumarray(E_(:), [...
 
 -(2.*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*((by - 2.*ay + cy)./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)) + (((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).*(2.*ay - 2.*by))./(2.*((ax - bx).^2 + (ay - by).^2).^(3./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)) + (((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).*(2.*ay - 2.*cy))./(2.*((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(3./2))))./(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2);
                                                                                                                                                                                                                                      -(2.*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*(ax - bx).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(((ax - bx).^2 + (ay - by).^2).^(3./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2).*(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2));
                                                                                                                                                                                                                                       (2.*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*(ax - cx).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(3./2).*(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2))]);
	g = [gx; gy]';
	g = g';
end
	% apply boundary condition (fix in place)
	% TODO linear
	g(flat(bnd)) = 0;
	g(flat(bnd)+nP) = 0;
end % compute gradient

	% box constraints
	c = [];
	% Hessian
	H = [];

end

