% Wed 26 Oct 15:12:05 CEST 2016
% Karl Kastner, Berlin
%
%% weighed Laplacian smoothing
% 
function obj = weighed_laplacian_smoothing(obj,maxiter)
	bndflag = 0;
	% fetch
	T  = obj.elem;
	X  = obj.X;
	Y  = obj.Y;
	bnd = obj.edge(obj.bnd,:);

	iter = 0;
	while (1)
		iter = iter+1;
		if (iter > maxiter)
			break;
		end % if

		X = X(T);
		Y = Y(T);
	
		% get opposit edge length
		dx = right(X)-left(X);
		dy = right(Y)-left(Y);
		l  = hypot(dx,dy);
		p = 1;
		l = p*l + (1-p)*mean(l(:));
	
		% get opposit edge mid point
		Xc = 0.5*(right(X)+left(X));
		Yc = 0.5*(right(Y)+left(Y));
	
		% accumulate weighed coordinates
		X = accumarray(T(:),l(:).*Xc(:));
		Y = accumarray(T(:),l(:).*Yc(:));
		W = accumarray(T(:),l(:));
	
		% normalise
		X = X./W;
		Y = Y./W;

		% apply boundary condition
		% TODO make boundary projection a function
		switch (bndflag)
		case {0}
			% constant, keep boundary points in place
			X(bnd) = obj.X(bnd);
			Y(bnd) = obj.Y(bnd);
		%case {1}
		%case {2}
		otherwise
			error('not implemented');
		end
	end % while

	% write back
	obj.point(:,1:2) = [X Y];
end % weighed_laplacian_smoothing

