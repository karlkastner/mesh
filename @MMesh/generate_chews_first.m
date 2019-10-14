% So 22. Nov 17:37:10 CET 2015
% Karl Kastner, Berlin

% TODO change orientation, if area is negative
% TODO check for overlapping lines
% TODO hide large edges
% TODO hide edges
% TODO split always largest triangle first
function [P T] = chews_first(P,E)
	abstol = 1e-3;

	% determine shortest edge h
	H = Geometry.edge_length(E,P);
	hmin = min(H);
	if (hmin < abstol)
		error('Edge of zero length');
	else
		printf(sprintf('minimum edge length %f\n',hmin));
	end
	% split large edges > 2h
	idx=1;
	np = size(P,1);
	ne = size(E,1);
	np0 = np;
	while (idx < ne)
		while (H(idx) > 2*hmin)
			xc = mean(P(E(idx,:),1));
			yc = mean(P(E(idx,:),2));
			np = np+1;
			P(np,:) = [xc yc];
			ne = ne+1;
			E(ne,:)  = [np E(idx,2)];
			% must come after previous line
			E(idx,2) = np;
			H(idx) = Geometry.edge_length(E(idx,:),P);
			H(ne) = Geometry.edge_length(E(ne,:),P);
		end
		idx=idx+1;
	end % while idx < ne

	% hide large edges > sqrt(3) h
	if (max(H) > sqrt(3)*hmin)
		warning('longest edge is too long')
	end

	jdx=0;
	while (true)
		jdx+1
		% triangulate
		DT = delaunayTriangulation(P,E);
		T = DT.ConnectivityList;
		% remove triangles outside the domain
		in = isInterior(DT);
		T = T(in,:);
%		pause
		% determine the centre of circumference
		[Xc Yc R] = Geometry.circumferencecircle( ... 
					[P(T(:,1),1) P(T(:,2),1) P(T(:,3),1)], ...
					[P(T(:,1),2) P(T(:,2),2) P(T(:,3),2)]);
		% determine the first triangle, where the cf is outside
		for idx=1:size(T,1)
			%c = Geometry.contains([P(T(idx,1),1) P(T(idx,2),1) P(T(idx,3),1)], ...
			%	     [P(T(idx,1),2) P(T(idx,2),2) P(T(idx,3),2)], Xc(idx), Yc(idx));
			c = R(idx) <= hmin;
			if (~c)
				% add the centre as new point
				if (inpoly([Xc(idx) Yc(idx)],P(1:np0,:)))
					np=np+1;
					P(np,:) = [Xc(idx), Yc(idx)];
					%clf
					%size(T)
					%triplot(T,P(:,1),P(:,2))
					%hold on
					%plot(P(np,1),P(np,2),'o')
					%pause(1)
					break;
				else
					warning('point outside domain, not added')
					c = true;
				end
			end
		end
		% if all triangles contain ther centre, return
		if (c)
			break;
		end
	end
end



