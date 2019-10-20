% Fri 28 Oct 13:42:26 CEST 2016
%
% wrapper for objective function that applies boundary conditions
%
function [f g H] = objective_A_bnd(obj,ofun,XYS,bndorder)
%	f_ = @objective_cosa_scaled_side_length;
%	fun = @objective_cosa;
%	bnd       = flat(obj.edge(obj.bnd,:));
%	flag      = true(obj.np,1);
%	flag(bnd) = false;
%	flag2     = [flag;flag];


	% set the new coordinates
	% TODO do not do this, pass the coordinate as argument
	% obj.point(:,1:2) = XY;

	% evaluate the derivative
	if (nargout() < 2)
		% the objective function and derivatives are only implemented in cartesian coordinates,
		% parametric coordinates have to be retransformed first
		[XY] = obj.xys2xy(XYS,bndorder);
	        [f]  = obj.objective_A(ofun,XY);
	else
		[XY dXY flag flagx flagy flagi] = obj.xys2xy(XYS,bndorder);
		if (nargout() < 3)
			[f g]      = obj.objective_A(ofun,XY);
		else
			[f g H]    = obj.objective_A(ofun,XY);
			if (isnan(f))
				return;
			end
			if (0 == bndorder)
				% delete rows and columns of boundary points
				H = H(flagi,:);
				H = H(:,flagi);
			else
				% combine columns and rowse of boundary points xy -> s
				H          = [H(flagi,:); bsxfun(@times, dXY(:,1),H(flagx,:)) +  bsxfun(@times,dXY(:,2),H(flagy,:))];
				H          = [H(:,flagi), bsxfun(@times,dXY(:,1)',H(:,flagx)) + bsxfun(@times,dXY(:,2)',H(:,flagy))];
			end
		end
		g = full(sum(g))';
		if (0 == bndorder)
			g = g(flagi);
		else
			% combine indices of boundary points
			g = [g(flagi); (dXY(:,1).*g(flagx) + dXY(:,2).*g(flagy))];
		end
	end % else of if nargout < 2

	% apply boundary condition
%	if (0 == order)
%		f = f(flagi);
%	else
%		f = [f(flagi); f(flagx)+f(flagy)];
%	end

	f = sum(f);

	% restore original coordinates
	% not necessary any more
	%obj.point(:,1:2) = XY0;
end % objective_A_bnd

