function associate_boundary()
	tol = 0.49;

		% find boundaries, that are close to the user-specified boundary
		% and sufficiently parrallel to it
		d   = Geometry.distance_point_to_line(Xb,Yb,xb(idx,:),yb(idx,:));
		fdx = find(d<tol*l);
		l_  = l(fdx);
		t_  = t(fdx,:);

