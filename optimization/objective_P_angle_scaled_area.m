% 2016-09-26 01:24:02 +0200 objective_angle_scaled
% Karl Kastner, Berlin
%
% E   : set of triangle point indices
% P   : point coordinates
% bnd : boundaries [pdx, left, right]
%
% TODO return box constraints of point movements (not beyond midpoints of adjoining edges)
% TODO this is not good, do not compute for max angle but max scaled f!
function [f g c H g_] = objective_angle_scaled(E,P,bnd)
	nT = size(E,1);
	nP = size(P,1);
	X = P(:,1);
	Y = P(:,2);

	% interior angles of triangles
	cosaT = Geometry.tri_angle(X(E),Y(E));
		
	% circumferencecircle of triangles
%	[void1 void2 Rc] = Geometry.circumferencecircle(X(E),Y(E));
	Rc = abs(Geometry.triarea(X(E),Y(E))).^0.25;

	% TODO the trifun only need to be explicitely evaluated for boundaries
	alphaT = acos(cosaT);

	% number of point neighbours
	nn     = accumarray(E(:),ones(3*nT,1));

	% compute optimum angle
	alpha0 = accumarray(E(:),alphaT(:))./nn;
	% TODO again only needs to be expl. evaluated for bnd points, as this is simply 2pi/nn for interior points
	cosa0   = cos(alpha0);

	% compute maximum angle
	%alpha_ = accumarray(E(:),alphaT(:),[],@max);
	mid   = accumarray(E(:),(1:3*nT)',[],@(id) maxid(alphaT(:),id));
	midT  = mod(mid-1,nT)+1;
	midC  = idivide(int32(mid-1),int32(nT))+1;
	alpha = alphaT(mid);

	% compute objective function value
	%f = (alpha-alpha0).^2;
	f = Rc(midT).^2.*(alpha-alpha0).^2;
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
	X = X(E_);
	Y = Y(E_);
	ax = X(:,1);
	bx = X(:,2);
	cx = X(:,3);
	ay = Y(:,1);
	by = Y(:,2);
	cy = Y(:,3);
	abx = bx-ax;
	aby = by-ay;
	acx = cx-ax;
	acy = cy-ay;
	bcx = cx-bx;
	bcy = cy-by;
%	ab = [ax-bx,ay-by];
%	ac = [ax-cx,ay-cy];
%	bc = [bx-cx,by-cy];
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


gx(E_(:,1)) = gx(E_(:,1)) + ...
   (2.^(1./2).*(abac - ab2.^(1./2).*ac2.^(1./2).*cosa0).^2.*(by./2 - cy./2))./(2.*ab2.*ac2.*(abx.*acy - aby.*acx).^(1./2)) - (2.^(1./2).*(abac - ab2.^(1./2).*ac2.^(1./2).*cosa0).*(abx.*acy - aby.*acx).^(1./2).*(ab2.*abx.*ac2 - ab2.*abac.*acx - abac.*abx.*ac2 + ab2.*ac2.*acx))./(ab2.^2.*ac2.^2);
gx(E_(:,2)) = gx(E_(:,2)) + ...
   (2.^(1./2).*aby.*(cosa0 - abac./(ab2.^(1./2).*ac2.^(1./2))).*(abx.*acy - aby.*acx).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(ab2.^(3./2).*ac2.^(1./2)) - (2.^(1./2).*(cosa0 - abac./(ab2.^(1./2).*ac2.^(1./2))).^2.*(ay./2 - cy./2))./(2.*(abx.*acy - aby.*acx).^(1./2));
gx(E_(:,3)) = gx(E_(:,3)) + ...
   (2^(1/2)*(cosa0 - abac./(ab2.^(1./2).*ac2.^(1./2))).^2.*(ay./2 - by./2))./(2.*(abx.*acy - aby.*acx).^(1./2)) - (2.^(1./2).*acy.*(cosa0 - abac./(ab2.^(1./2).*ac2.^(1./2))).*(abx.*acy - aby.*acx).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(ab2.^(1./2).*ac2.^(3./2));
 
gy(E_(:,1)) = gy(E_(:,1)) + ...
 - (2.^(1./2).*(abac - ab2.^(1./2).*ac2.^(1./2).*cosa0).^2.*(bx./2 - cx./2))./(2.*ab2.*ac2.*(abx.*acy - aby.*acx).^(1./2)) - (2.^(1./2).*(abac - ab2.^(1./2).*ac2.^(1./2).*cosa0).*(abx.*acy - aby.*acx).^(1./2).*(ab2.*aby.*ac2 - ab2.*abac.*acy - abac.*aby.*ac2 + ab2.*ac2.*acy))./(ab2.^2.*ac2.^2);
gy(E_(:,2)) = gy(E_(:,2)) + ...
     (2.^(1./2).*(cosa0 - abac./(ab2.^(1./2).*ac2.^(1./2))).^2.*(ax./2 - cx./2))./(2.*(abx.*acy - aby.*acx).^(1./2)) - (2.^(1./2).*abx.*(cosa0 - abac./(ab2.^(1./2).*ac2.^(1./2))).*(abx.*acy - aby.*acx).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(ab2.^(3./2).*ac2.^(1./2));
gy(E_(:,3)) = gy(E_(:,3)) + ...
     (2.^(1./2).*acx.*(cosa0 - abac./(ab2.^(1./2).*ac2.^(1./2))).*(abx.*acy - aby.*acx).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(ab2.^(1./2).*ac2.^(3./2)) - (2.^(1./2).*(cosa0 - abac./(ab2.^(1./2).*ac2.^(1./2))).^2.*(ax./2 - bx./2))./(2.*(abx.*acy - aby.*acx).^(1./2));
else

gx(E_(:,1)) = gx(E_(:,1)) + ...
(2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).^2.*(by - cy))./(4.*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2)) - (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2).*((bx - 2.*ax + cx)./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)) + (((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).*(2.*ax - 2.*bx))./(2.*((ax - bx).^2 + (ay - by).^2).^(3./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)) + (((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).*(2.*ax - 2.*cx))./(2.*((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(3./2))))./(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2);
gx(E_(:,2)) = gx(E_(:,2)) + ...
                                                                                                                                                                                                                                      (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2).*(ay - by).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(((ax - bx).^2 + (ay - by).^2).^(3./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2).*(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2)) - (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).^2.*(ay - cy))./(4.*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2));
gx(E_(:,3)) = gx(E_(:,3)) + ...
                                                                                                                                                                                                                                      (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).^2.*(ay - by))./(4.*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2)) - (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2).*(ay - cy).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(3./2).*(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2));



gy(E_(:,1)) = gy(E_(:,1)) + ...
 - (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).^2.*(bx - cx))./(4.*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2)) - (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2).*((by - 2.*ay + cy)./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)) + (((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).*(2.*ay - 2.*by))./(2.*((ax - bx).^2 + (ay - by).^2).^(3./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)) + (((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).*(2.*ay - 2.*cy))./(2.*((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(3./2))))./(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2);
gy(E_(:,2)) = gy(E_(:,2)) + ...
                                                                                                                                                                                                                                        (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).^2.*(ax - cx))./(4.*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2)) - (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2).*(ax - bx).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(((ax - bx).^2 + (ay - by).^2).^(3./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2).*(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2));
gy(E_(:,3)) = gy(E_(:,3)) + ...
                                                                                                                                                                                                                                        (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2).*(ax - cx).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(3./2).*(1 - ((ax - bx).*(ax - cx) + (ay - by).*(ay - cy)).^2./(((ax - bx).^2 + (ay - by).^2).*((ax - cx).^2 + (ay - cy).^2))).^(1./2)) - (2.^(1./2).*(alpha0 - acos(((ax - bx).*(ax - cx) + (ay - by).*(ay - cy))./(((ax - bx).^2 + (ay - by).^2).^(1./2).*((ax - cx).^2 + (ay - cy).^2).^(1./2)))).^2.*(ax - bx))./(4.*((ax - bx).*(ay - cy) - (ay - by).*(ax - cx)).^(1./2));

end

g = [gx; gy]';

	% apply boundary condition (fix in place)
	% TODO linear
	g(flat(bnd)) = 0;
	g(flat(bnd)+nP) = 0;
	g=g';
	if (nargout() > 4)
	g_ = zeros(2*nP,1);
	for idx=1:size(E_,1)
		x = rvec(X(E_(idx,:)));
		y = rvec(Y(E_(idx,:)));
		[f_(idx,1) Rc_(idx,1)]   = fun(x,y,alpha0(idx));
		g__ = grad(@(xy) fun([xy(1:3)'],[xy(4:6)'],alpha0(idx)),[x y]');
		g_(E_(idx,1)) = 		g_(E_(idx,1)) + g__(1);
		g_(E_(idx,2)) = 		g_(E_(idx,2)) + g__(2);
		g_(E_(idx,3)) = 		g_(E_(idx,3)) + g__(3);
		g_(nP+E_(idx,1)) = 		g_(nP+E_(idx,1)) + g__(4);
		g_(nP+E_(idx,2)) = 		g_(nP+E_(idx,2)) + g__(5);
		g_(nP+E_(idx,3)) = 		g_(nP+E_(idx,3)) + g__(6);
	end
	g_ = g_(:)';
	end
	end
	

	% numerical gradient for testing
	function [f Rc] = fun(x,y,alpha0)
		%[void1 void2 Rc]    = Geometry.circumferencecircle(x,y);
		Rc    = abs(Geometry.triarea(x,y)).^0.25;
		cosa = Geometry.tri_angle(x,y);
		alpha = acos(cosa);
		f     = (alpha(1)-alpha0).^2;
		f = Rc.^2*f;
		%f     = Rc.^2.*(alpha(1)-alpha0).^2; 
	end
	% box constraints
	c = [];
	H = [];

end

