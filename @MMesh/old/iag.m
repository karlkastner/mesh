if (0)
	if (order < 2)
		% gradient optimisation
		% evaluate functions at start point
		[f0 g] = func(P,elem);
		g      = reshape(g,obj.np,2);
		% line search of minimum in the direction of the gradient
		% h = 1/(g'*g);
		fr = func(P(:,1:2) - h*g,elem);
		[f x h] = line_search(@(x) func(P(:,1:2) + x,elem),g,0,h,f0,fr,maxiter);
		% overdamping
		% h = 0.125*h;
	else % quadratic optimisation
		% evaluate function at start point
		tic
		[f0 g0 H] = func(P,elem);
		printf('Computation of gradient and Hessian took %f seconds\n',toc);
		% determine
		%dP = - H \ g0;
		tic
		dP = - gmres(H,g0);
		printf('System solution took %f seconds\n',toc);
		dP = reshape(dP,obj.np,2);
		% this is a non-linear optimisation, thus perfor line search
		h = -1;
		g = dP; % 2* ?
		fr = func(P(:,1:2) - h*g,elem);
		tic
		[f x h] = line_search(@(x) func(P(:,1:2) + x,elem),g,0,h,f0,fr,maxiter);
		printf('Line search took %f seconds\n',toc);
	end
	% step
	P(:,1:2) = P(:,1:2) - h*g;
end

