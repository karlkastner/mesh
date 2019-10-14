% 2016-09-26 01:24:02 +0200 objective_angle_scaled
% Karl Kastner, Berlin
%
% E   : set of triangle point indices
% P   : point coordinates
% bnd : boundaries [pdx, left, right]
%
% TODO return box constraints of point movements (not beyond midpoints of adjoining edges)
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
	ab = [ax-bx,ay-by];
	ac = [ax-cx,ay-cy];
	bc = [bx-cx,by-cy];
	abab = ab(:,1).^2 + ab(:,2).^2;
	acac = ac(:,1).^2 + ac(:,2).^2;
	abac = (ab(:,1).*ac(:,1) + ab(:,2).*ac(:,2));

rad = 0;
if (rad)	
	g = ...
((cosa0 - abac./(abab.^(1./2).*acac.^(1./2))).*((bx - 2.*ax + cx)./(abab.^(1./2).*acac.^(1./2)) + (abac.*(2.*ax - 2.*bx))./(2.*abab.^(3./2).*acac.^(1./2)) + (abac.*(2.*ax - 2.*cx))./(2.*abab.^(1./2).*acac.^(3./2))).*(ax.^2 - 2.*ax.*bx + ay.^2 - 2.*ay.*by + bx.^2 + by.^2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) - (2.*((ab(:,2).*ac(:,2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) + 1./2).*(bx./2 - ax./2 + (ab(:,2).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))) - ((bx - cx).*(ay./2 - by./2 + (ab(:,1).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(ax.^2.*by - ax.^2.*cy - 2.*ax.*ay.*bx + 2.*ax.*ay.*cx + 2.*ax.*bx.*cy - 2.*ax.*by.*cx - ay.^2.*by + ay.^2.*cy + ay.*bx.^2 + ay.*by.^2 - ay.*cx.^2 - ay.*cy.^2 - bx.^2.*cy - by.^2.*cy + by.*cx.^2 + by.*cy.^2))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2).*(cosa0 - abac./(abab.^(1./2).*acac.^(1./2))).^2;


	g = [g; 
(2.*((ab(:,1).*ac(:,1).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) + 1./2).*(ay./2 - by./2 + (ab(:,1).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))) - ((by - cy).*(bx./2 - ax./2 + (ab(:,2).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(- ax.^2.*bx + ax.^2.*cx - 2.*ax.*ay.*by + 2.*ax.*ay.*cy + ax.*bx.^2 + ax.*by.^2 - ax.*cx.^2 - ax.*cy.^2 + ay.^2.*bx - ay.^2.*cx - 2.*ay.*bx.*cy + 2.*ay.*by.*cx - bx.^2.*cx + bx.*cx.^2 + bx.*cy.^2 - by.^2.*cx))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2).*(cosa0 - abac./(abab.^(1./2).*acac.^(1./2))).^2 + ((cosa0 - abac./(abab.^(1./2).*acac.^(1./2))).*((by - 2.*ay + cy)./(abab.^(1./2).*acac.^(1./2)) + (abac.*(2.*ay - 2.*by))./(2.*abab.^(3./2).*acac.^(1./2)) + (abac.*(2.*ay - 2.*cy))./(2.*abab.^(1./2).*acac.^(3./2))).*(ax.^2 - 2.*ax.*bx + ay.^2 - 2.*ay.*by + bx.^2 + by.^2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2)];

else

gx = zeros(nP,1);
gy = zeros(nP,1);
gx(E_(:,1)) = gx(E_(:,1)) + ...
[- (alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).^2.*(2.*((ab(:,2).*ac(:,2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) + 1./2).*(bx./2 - ax./2 + (ab(:,2).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))) - (bc(:,1).*(ay./2 - by./2 + (ab(:,1).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(ax.^2.*by - ax.^2.*cy - 2.*ax.*ay.*bx + 2.*ax.*ay.*cx + 2.*ax.*bx.*cy - 2.*ax.*by.*cx - ay.^2.*by + ay.^2.*cy + ay.*bx.^2 + ay.*by.^2 - ay.*cx.^2 - ay.*cy.^2 - bx.^2.*cy - by.^2.*cy + by.*cx.^2 + by.*cy.^2))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) - ((alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).*((bx - 2.*ax + cx)./(abab.^(1./2).*acac.^(1./2)) + (abac.*(2.*ax - 2.*bx))./(2.*abab.^(3./2).*acac.^(1./2)) + (abac.*(2.*ax - 2.*cx))./(2.*abab.^(1./2).*acac.^(3./2))).*(ax.^2 - 2.*ax.*bx + ay.^2 - 2.*ay.*by + bx.^2 + by.^2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*(1 - abac.^2./(abab.*acac)).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2)
];

gx(E_(:,2)) = gx(E_(:,2)) + ...
(alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).^2.*(2.*((ab(:,2).*bc(:,2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) + 1./2).*(bx./2 - ax./2 + (ab(:,2).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))) + (ac(:,1).*(ay./2 - by./2 + (ab(:,1).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(ax.^2.*by - ax.^2.*cy - 2.*ax.*bx.*by + 2.*ax.*bx.*cy + ay.^2.*by - ay.^2.*cy + ay.*bx.^2 - 2.*ay.*bx.*cx - ay.*by.^2 + ay.*cx.^2 + ay.*cy.^2 - bx.^2.*cy + 2.*bx.*by.*cx + by.^2.*cy - by.*cx.^2 - by.*cy.^2))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) + ((alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).*ab(:,2).*(ax.^2 - 2.*ax.*bx + ay.^2 - 2.*ay.*by + bx.^2 + by.^2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*abab.^(3./2).*acac.^(1./2).*(1 - abac.^2./(abab.*acac)).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx));

gx(E_(:,3)) = gx(E_(:,3)) + ...
(alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).^2.*((ab(:,1).*(ay./2 - by./2 + (ab(:,1).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(- ax.^2.*by + ax.^2.*cy + 2.*ax.*by.*cx - 2.*ax.*cx.*cy - ay.^2.*by + ay.^2.*cy + ay.*bx.^2 - 2.*ay.*bx.*cx + ay.*by.^2 + ay.*cx.^2 - ay.*cy.^2 - bx.^2.*cy + 2.*bx.*cx.*cy - by.^2.*cy - by.*cx.^2 + by.*cy.^2))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2 + (ab(:,2).*(bx./2 - ax./2 + (ab(:,2).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(- ax.^2.*by + ax.^2.*cy + 2.*ax.*by.*cx - 2.*ax.*cx.*cy - ay.^2.*by + ay.^2.*cy + ay.*bx.^2 - 2.*ay.*bx.*cx + ay.*by.^2 + ay.*cx.^2 - ay.*cy.^2 - bx.^2.*cy + 2.*bx.*cx.*cy - by.^2.*cy - by.*cx.^2 + by.*cy.^2))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) - ((alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).*ac(:,2).*(ax.^2 - 2.*ax.*bx + ay.^2 - 2.*ay.*by + bx.^2 + by.^2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*abab.^(1./2).*acac.^(3./2).*(1 - abac.^2./(abab.*acac)).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx)); 

gy(E_(:,1)) = gy(E_(:,1)) + ...
(alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).^2.*(2.*((ab(:,1).*ac(:,1).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) + 1./2).*(ay./2 - by./2 + (ab(:,1).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))) - (bc(:,2).*(bx./2 - ax./2 + (ab(:,2).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(- ax.^2.*bx + ax.^2.*cx - 2.*ax.*ay.*by + 2.*ax.*ay.*cy + ax.*bx.^2 + ax.*by.^2 - ax.*cx.^2 - ax.*cy.^2 + ay.^2.*bx - ay.^2.*cx - 2.*ay.*bx.*cy + 2.*ay.*by.*cx - bx.^2.*cx + bx.*cx.^2 + bx.*cy.^2 - by.^2.*cx))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) - ((alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).*((by - 2.*ay + cy)./(abab.^(1./2).*acac.^(1./2)) + (abac.*(2.*ay - 2.*by))./(2.*abab.^(3./2).*acac.^(1./2)) + (abac.*(2.*ay - 2.*cy))./(2.*abab.^(1./2).*acac.^(3./2))).*(ax.^2 - 2.*ax.*bx + ay.^2 - 2.*ay.*by + bx.^2 + by.^2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*(1 - abac.^2./(abab.*acac)).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2);

gy(E_(:,2)) = gy(E_(:,2)) + ...
- (alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).^2.*(2.*((ab(:,1).*bc(:,1).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) + 1./2).*(ay./2 - by./2 + (ab(:,1).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))) - (ac(:,2).*(bx./2 - ax./2 + (ab(:,2).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(- ax.^2.*bx + ax.^2.*cx + ax.*bx.^2 - ax.*by.^2 + 2.*ax.*by.*cy - ax.*cx.^2 - ax.*cy.^2 - ay.^2.*bx + ay.^2.*cx + 2.*ay.*bx.*by - 2.*ay.*by.*cx - bx.^2.*cx - 2.*bx.*by.*cy + bx.*cx.^2 + bx.*cy.^2 + by.^2.*cx))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2) - ((alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).*ab(:,1).*(ax.^2 - 2.*ax.*bx + ay.^2 - 2.*ay.*by + bx.^2 + by.^2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*abab.^(3./2).*acac.^(1./2).*(1 - abac.^2./(abab.*acac)).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx));

gy(E_(:,3)) = gy(E_(:,3)) + ...
((alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).*ac(:,1).*(ax.^2 - 2.*ax.*bx + ay.^2 - 2.*ay.*by + bx.^2 + by.^2).*(ax.^2 - 2.*ax.*cx + ay.^2 - 2.*ay.*cy + cx.^2 + cy.^2).*(bx.^2 - 2.*bx.*cx + by.^2 - 2.*by.*cy + cx.^2 + cy.^2))./(2.*abab.^(1./2).*acac.^(3./2).*(1 - abac.^2./(abab.*acac)).^(1./2).*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx)) - (alpha0 - acos(abac./(abab.^(1./2).*acac.^(1./2)))).^2.*((ab(:,1).*(ay./2 - by./2 + (ab(:,1).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(- ax.^2.*bx + ax.^2.*cx + ax.*bx.^2 + ax.*by.^2 - 2.*ax.*by.*cy - ax.*cx.^2 + ax.*cy.^2 - ay.^2.*bx + ay.^2.*cx + 2.*ay.*bx.*cy - 2.*ay.*cx.*cy - bx.^2.*cx + bx.*cx.^2 - bx.*cy.^2 - by.^2.*cx + 2.*by.*cx.*cy))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2 + (ab(:,2).*(bx./2 - ax./2 + (ab(:,2).*(ax.*bx + ay.*by - ax.*cx - ay.*cy - bx.*cx - by.*cy + cx.^2 + cy.^2))./(2.*(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx))).*(- ax.^2.*bx + ax.^2.*cx + ax.*bx.^2 + ax.*by.^2 - 2.*ax.*by.*cy - ax.*cx.^2 + ax.*cy.^2 - ay.^2.*bx + ay.^2.*cx + 2.*ay.*bx.*cy - 2.*ay.*cx.*cy - bx.^2.*cx + bx.*cx.^2 - bx.*cy.^2 - by.^2.*cx + 2.*by.*cx.*cy))./(ax.*by - ay.*bx - ax.*cy + ay.*cx + bx.*cy - by.*cx).^2);
g = [gx; gy]';

	% apply boundary condition (fix in place)
	% TODO linear
	g(flat(bnd)) = 0;
	g(flat(bnd)+nP) = 0;
	g=g';
end
	if (nargout() > 3)
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

