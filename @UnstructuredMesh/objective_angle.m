% Sa 19. Dez 19:56:27 CET 2015
% Karl Kastner, Berlin
%
%% objective function for iterative angle improvement
%
% use of Hessian not recommended, as non-linear cg is more efficient
% and does not require the Hessian
%
% P is stacked as 2*np x 1 vector, for use in general solvers
% note that the gradient is interleaved and not stacked
function [f g H] = objective_angle2(P,elem,bnd)
	np  = size(P,1)/2;
	ne  = size(elem,1);
	f   = 0;
	pdx = [1 2 3 1 2];

	% fun = @ddot
	% TODO determine cosa0 for each point individually
	cosa0 = cos(deg2rad(90));
%	fun = @(a,b,c) objective0_angle2_barycentric9(a,b,c,cosa0);
	%fun = @(a,b,c) objective0_angle2_cartesian(a,b,c,cosa0);
	fun = @(a,b,c) ddot(a,b,c);
	%fun = @(a,b,c) objective0_angle1_barycentric(a,b,c,cosa0);
	%fun = @(a,b,c) objective_angle1_barycentric(a,b,c,cosa0);
	%fun = @(a,b,c) objective_angle1_cartesian(a,b,c,cosa0);
	%fun = @(a,b,c) objective0_pythagoras1_barycentric9(a,b,c,cosa0);
	%fun = @(a,b,c) objective0_pythagoras2_barycentric9(a,b,c,cosa0);
	%fun = @(a,b,c) objective0_pythagoras2_cartesian(a,b,c,cosa0);
	%fun = @(a,b,c) objective0_pythagoras1_cartesian(a,b,c,cosa0);

	% for each angle of the elements
	if (nargout() > 1)
		g = zeros(2*np,1);
		if (nargout() > 2)
			H = zeros(36*ne,3);
			nh = 0;
		end
	end
	% for each angle
	% TODO shifting and accumulation should be part of the objective function,
	%      as some objective functions are only one valued and not three valued
	for adx=1:3
		switch (nargout)
		case {1}
			[f_]       = fun([  P(elem(:,pdx(adx)))'; P(elem(:,pdx(adx))+np)'] ...
					,[P(elem(:,pdx(adx+1)))'; P(elem(:,pdx(adx+1))+np)'] ...
					,[P(elem(:,pdx(adx+2)))'; P(elem(:,pdx(adx+2))+np)']);
		case {2}
			[f_ g_]    = fun([  P(elem(:,pdx(adx)))'; P(elem(:,pdx(adx))+np)'] ...
					,[P(elem(:,pdx(adx+1)))'; P(elem(:,pdx(adx+1))+np)'] ...
					,[P(elem(:,pdx(adx+2)))'; P(elem(:,pdx(adx+2))+np)']);
		case {3}
			[f_ g_ H_]    = fun([  P(elem(:,pdx(adx)))'; P(elem(:,pdx(adx))+np)'] ...
					   ,[P(elem(:,pdx(adx+1)))'; P(elem(:,pdx(adx+1))+np)'] ...
					   ,[P(elem(:,pdx(adx+2)))'; P(elem(:,pdx(adx+2))+np)']);
%			[f_ g_ H_] = fun(P(elem(:,pdx(adx)),:),P(elem(:,pdx(adx+1)),:),P(elem(:,pdx(adx+2)),:));
		end % switch
		% accummulate objective function value
		f = f + sum(f_);
		% accumulate the gradient
		if (nargout > 1)
			g_ = g_';
			% accumulate the gradients (local to global indices)
			for idx=1:3
				% x-coordinate
				g = g + accumarray(   elem(:,pdx(adx+idx-1)),g_(:,2*idx-1),[2*np 1]);
				% y-coordinate
				g = g + accumarray(np+elem(:,pdx(adx+idx-1)),g_(:,2*idx),[2*np 1]);
			end % for idx
			if (nargout > 2)
				% accumulate the hessian
				for idx=1:3
					for jdx=1:3
						H(nh+1:nh+ne,:) = [ elem(:,pdx(adx+idx-1)), elem(:,pdx(adx+jdx-1)), squeeze(H_(2*idx-1,2*jdx-1,:))];
						nh = nh+ne;
						H(nh+1:nh+ne,:) = [ elem(:,pdx(adx+idx-1))+np, elem(:,pdx(adx+jdx-1)), squeeze(H_(2*idx,2*jdx-1,:))];
						nh = nh+ne;
						H(nh+1:nh+ne,:) = [ elem(:,pdx(adx+idx-1)), elem(:,pdx(adx+jdx-1))+np, squeeze(H_(2*idx-1,2*jdx,:))];
						nh = nh+ne;
						H(nh+1:nh+ne,:) = [ elem(:,pdx(adx+idx-1))+np, elem(:,pdx(adx+jdx-1))+np, squeeze(H_(2*idx,2*jdx,:))];
						nh = nh+ne;
					end % for jdx
				end % for idx
			end % if nargout > 2
		end % if nargout > 1
	end % for adx
	if (nargout() > 1)
		% project to boundary
		if (~isempty(bnd))
			g = flat(UnstructuredMesh.project_to_boundary(reshape(g,[],2),reshape(P,[],2),bnd));
		end

		if (nargout > 2)
			% TODO Hessian needs to be coorected at the boundary
			H = sparse(H(:,1),H(:,2),H(:,3),2*np,2*np);
	%		'symmetry'
	%		sum(sum((H-H').^2))
		end % if nargout > 2
	%g = g';
	end % if nargout > 1
	DEBUG = false;
	if (DEBUG)
		X = reshape(P(elem),[],3);
		Y = reshape(P(elem+np),[],3);
		[Xc Yc R] = Geometry.circumferencecircle(X,Y);
		ortho     = Geometry.contains(X,Y,Xc,Yc);
		fprintf(1,'Number of obtuse triangle %d\n',sum(~ortho));
	end
end % objective_angle

