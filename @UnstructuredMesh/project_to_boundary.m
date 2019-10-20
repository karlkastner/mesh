% Sat 11 Jun 15:27:15 CEST 2016
% Karl Kastner, Berlin
%
%% project a point to the boundary
function g = project_to_boundary(g,XY,bnd,order)
	% TODO no magic numbers
	switch (order)
	case {0} % constant, % zero order
		% restore boundary points locations
		g(bnd(:,1),:) = 0;
	case {1} % projection to tangent determined by linear function
		% project the gradient of boundary point along the dirction of the boundary
		% direction at the boundary points (linear approximation)
		dx  = XY(bnd(:,3),1) - XY(bnd(:,2),1);
		dy  = XY(bnd(:,3),2) - XY(bnd(:,2),2);
		l   = hypot(dx,dy);
		dx = dx./l;
		dy = dy./l;
		% magnitude of gradient in direction along boundary (inner product)
		mag = dx.*g(bnd(:,1),1) + dy.*g(bnd(:,1),2);
		%mag = dx.*g(bnd(:,1)) + dy.*g(bnd(:,1)+np);
		%mag = dx.*g(2*bnd(:,1)-1) + dy.*g(2*bnd(:,1));
		% split magnitude in components (outer product)
		%g(2*bnd(:,1)-1) = dx.*mag;
		%g(2*bnd(:,1))   = dy.*mag;
		g(bnd(:,1),1)  = dx.*mag;
		g(bnd(:,1),2)  = dy.*mag;
	case {2}
	% quadratic, todo, use ful quadratic
	% cirular boundary projection
		% get left and right neighbour of each boundary point
		T = zeros(np,2);
		fdx = false(np,1);
		for idx=1:size(bnd,1)
			fdx(bnd(idx,1)) = true;
			if (0 == T(bnd(idx,1),1))
				T(bnd(idx,1),1) = bnd(idx,2);
			else
				T(bnd(idx,1),2) = bnd(idx,2);
			end
			fdx(bnd(idx,2)) = true;
			if (0 == T(bnd(idx,2),1))
				T(bnd(idx,2),1) = bnd(idx,1);
			else
				T(bnd(idx,2),2) = bnd(idx,1);
			end
		end
		fdx = find(fdx);
		T  = [fdx, T(fdx,:)];
		% regress circumferencecircles
		% TODO, if R > 1e7, project linearly
		[Xc Yc R] = Geometry.circumferencecircle(X0(T),Y0(T));
		% get direction
		dX = X(fdx) - Xc;
		dY = Y(fdx) - Yc;
		h  = hypot(dX,dY);
		% projected points
		X_ = Xc + dX.*R./h;
		Y_ = Yc + dY.*R./h;
		X(fdx) = X_;
		Y(fdx) = Y_;
	end % if
end % project_to_boundary

