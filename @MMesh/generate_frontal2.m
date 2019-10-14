% 2015-11-22 19:40:44.490305434 +0100
% Karl Kastner, Berlin
%
%function [X Y T] = frontal(X,Y)
%	% TODO ensure orientation of the polygon
%
%	np = length(X);
%	ne = np;
%	% boundary
%	E = [(1:np)', [(2:ne)', 1]];
%	l = zeros(ne,1);
%	% set up initial length
%	for idx=1:np
%		l = len()
%	end
%
%	% initial length
%	while (~isempty(E))
%		% select shortest edge
%		[l0 mdx] = min(l);
%		h = sqrt(3)*l0;
%		% TODO average length of element and length of neighbours
%		[cx cy]  = midpoint(X(E(mdx,:)),Y(E(mdx,:)));
%		odir     = normal(X(E(mdx,:)),Y(E(mdx,:)));
%		% propose point at height sqrt(3)*l
%		px = cx + h*odir(1)*sqrt(3);
%		py = cy + h*odir(2)*sqrt(3);
%		% check if the triangle cuts the front
%		smin = inf;
%		imin = 0;
%		for idx=1:ne
%			Geometry.lineintersect();
%			% check for convexity
%			if (t >= 0 & t <= 1)
%			if (s > 0 & s < smin)
%				smin = s;
%				if (s <= h)
%					imin = idx;
%				end
%			end  % if intersection
%			% is convex
%		end
%		% if this cuts the front, connect to closest point of the nearest cutting front
%		if (imin > 0)
%			% intersection, do not insert a new point, but connect to the closest opposit point
%			d1 = dist2(cx,cy,X(E(imin,1)),Y(E(imin,1)));
%			d2 = dist2(cx,cy,X(E(imin,2)),Y(E(imin,2)));
%			if (d1 < d2)
%				np_ = E(imin,1);
%			else
%				np_ = E(imin,2);
%			end
%		else
%			% do not put new point closer than half distance to the opposit element
%			if (s < 2*h)
%				h = s/2;
%				px = cx + h*odir(1)*sqrt(3);
%				py = cy + h*odir(2)*sqrt(3);
%			end
%			% add point
%			np = np+1;
%			X(np) = px;
%			Y(np) = py;
%		end
%		% new element
%		nt = nt+1;
%		T(nt,:) = [E(mdx,1),np,E(mdx,2)];
%		% new edge
%		ne = ne+1;
%		% TODO, do not insert twice, but remove if edges already exist
%		fdx = find( (E(:,1)==E(mdx,2)).*(E
%		if (~isempty(E))
%			
%		end
%		E(ne,:) = [E(mdx,1),np];
%		% replace edge
%		E(mdx,1) = np;
%		% update length
%		l(mdx) = leng()
%		l(ne)  = leng()
%	end % while the front is not empty
%end % function frontal

