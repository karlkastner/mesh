% 2015-12-01 14:49:00.769807925 +0100
% Karl Kastner, Berlin

%closure:
%
%% get bounary nodes and associated boundary edges
%Eb = obj.E(obj.bnd,:);
%Pb = zeros(obj.np,4);
%% we keep the point twice to preserve cw/ccw orientation
%for idx=1:size(Eb,1)
%	p1 = Eb(idx,1),1);
%	p2 = Eb(idx,1),1);
%	if (0 == Pb(p1,1))
%		Pb(p1,1:2) = [p1 p2];
%	else
%		Pb(p1,3:4) = [p1 p2];
%	end
%	if (0 == Pb(p2,1))
%		Pb(p2,1:2) = [p1 p2];
%	else
%		Pb(p2,3:4) = [p1 p2];
%	end
%end
%% remove non-boundary points
%fdx = find(Pb(:,1));
%Pb  = Pb(fdx,:);
%
%% distinguish outer and inner bn
%dx1  = P(Pb(:,2),1)-P(Pb(:,1),1);
%dy1  = P(Pb(:,4),2)-P(Pb(:,3),2);
%dx2  = P(Pb(:,2),1)-P(Pb(:,1),1);
%dy2  = P(Pb(:,4),2)-P(Pb(:,3),2);
%cosa = Geometry.dot(dx1,dy1,dx2,dy2);
%sina = Geometry.cross2(dx1,dy1,dx2,dy2);
%angle = atan2(sina,cosa);
%angle = deg2rad(angle);
%
%% each boundary node
%% add boundary ray
%for idx=1:length(pbnd)
%	a = angle(idx);
%	if (angle < -150 || angle >= 150)
%		% 180 deg, straight, follow perpendicular
%		np = np+1;
%		point(np,1) = px + dy;
%		point(np,2) = py + dx;
%	elseif (angle < -90 )
%		% - 120 deg, convex, follow halving angle
%	elseif (angle < -30 )
%		% -60 deg
%		% do nothing
%	elseif (angle < 30 )
%		% 0 deg (straight)
%		np = np+1;
%		point(np,1) = px - dy;
%		point(np,2) = py - dx;
%	elsif (angle < 90 deg)
%		% 60 deg
%		% insert two perpendicular and one halving
%	elseif (angle < 150)
%		% 
%	else
%		% 120 (300) deg
%	end
%
%	% concave (120 deg)
%	if (a > -pi/2 && a < -pi/2u)
%		angle bisector
%	else
%	if (a >
%case 0/180 straight
%	perpendiculat
%- if 240 convex
%	two perpendicular
%
%	% 300
%	if (a > 270
%	two perpendicular + 1/2
%	end
%
%% for each boundary ray,
%% cut at nearest bnd
%for idx=1:npbnd
%	Geometry.lineintersect();
%	
%end
%	
%% triangulate
%
%- closure
%- make corners square 90 deg corners
%- at each mesh bnd point, extend vertical towards the boundary to form a 5-gon
%- triangulate in two triangles
%- lower triangle could become obtuse if dh > sqrt(2h), but this cannot occur,
%  because in this case a regular triangle would have been inserted
%  or if the edge is non-smooth/underresolved, so limit dh to sqrt(2h)
%- corner closure, extend both ends
%
