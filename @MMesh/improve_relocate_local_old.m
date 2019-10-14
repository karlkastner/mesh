% Sa 13. Feb 19:08:02 CET 2016
% Karl Kastner, Berlin
%
% iteratively improve angles to remove obtuse triangles
%
function obj = imrpove_angle_local(obj,MaxIter)
	if (nargin() < 2)
		MaxIter = 100;
		maxit   = 10;
	end
	[void void pte_C] = obj.point_to_elem();

	ptp_C = obj.vertex_connectivity();

	idx = 0;
	no_old = inf;
	% TODO use solver here
	while (true)
		idx=idx+1;
		% determine obtuse triangles
		to = find(~obj.check_orthogonality());
		no = length(to);
		% stop if there are no more obtuse triangles
		if (isempty(to))
			printf('Optimisation convcerged at step %d\n');
			break;
		end
		% stop if maximum number of iterations has been reached
		if (idx > MaxIter)
			printf('Stopped at sted %d without convergence as maximum number of iterations has been reached\n',idx);
			break;
		end
		if (no == no_old)
			printf('Stopped at sted %d without convergence as number of obtuse triangles was not further reduced\n',idx);
			break;
		end
		printf('Iteration %d %d obtuse triangles\n',idx,length(to));

		Hh = zeros(length(to),1);

		% for each obtuse triangle
		for jdx=1:length(to)
			% vertices of the obtuse triangle
			po = obj.elem(to(jdx),:);

			% check which of the angles is the obtuse one
			cosa          = obj.angle(to(jdx));
			[cosamin mdx] = min(cosa);
			po = po(mdx);
			% get neighbouring points (level 1)
			p1 = find(ptp_C(:,idx));
%			p1 = ptp_C{po};
			%p1 = unique(vertcat(p1{:}));
			%obj.point_neighbours(po(jdx));
			% get all indices elements associated with these points
			tdxg = [];
			for pdx=1:length(p1)
				tdxg = [tdxg; find(pte_C(p1(pdx),:))'];
			end
			tdxg = unique(tdxg);
%			tdxg = pte_C(p1);
%			tdxg = unique(horzcat(tdxg{:}));
			% get elements in point index form
			Tg   = obj.elem(tdxg,:);
			if (0)
				% get second level neighbours
				% p2 = obj.point_neighbours(p1);
				% get all angle indices associated with the neighbours and itself
				Ag = obj.angle([p1;to(idx)]);
				% transfrom global to local index
				[pdxg ia] = unique(Ag);
				pdx = (1:length(p))';
				Al = pdx(ia);
				% get associated points coordinates
				Xl = obj.point(pdxg,1);
				Yl = obj.point(pdxg,2);
				Pl = [X Y];
				% compute value and derivatives of local optimisation function
				[f g H] = fun(Al,Pl);
			end
			% global point indices
			[pdxg ig il] = unique(Tg);
			%pdxl = (1:length(pdxg))';
			% coordinates of local points 
			Pl  = obj.point(pdxg,1:2);
			% shift locally, to improve numberical accuracy
			Pl  = bsxfun(@minus,Pl,obj.point(po,1:2));
			% elements as indices into local point coordinates
			Tl  = reshape(il,[],3); %pdxl(il);

			% indices of inner points
			fdx = ismember(pdxg,p1); 
			%(pdxg == T1(1)) | (pdxg == T1(2)) | (pdxg == T1(3));
			% double stack for x and y coordinate
			fdx2 = [fdx;fdx];

			% compute value and derivatives of local optimisation function
			% not necessary to reduce points to local coordinates here
			[f g H] = obj.objective_angle(Pl(:),Tl,[]);

%			[H_ g_ f_] = hessian(@(Pl) obj.objective_angle(reshape(Pl,[],2),Tl), Pl(:));
			% freeze points at boundary by removing their rows and columns
			P0   = reshape(Pl(fdx,:),[],1);
			% compute linearized optimum
			Popt = P0 - (H(fdx2,fdx2)\g(fdx2));
%			Popt_ = P0 - (H_(fdx2,fdx2)\g_(fdx2));
			Popt = reshape(Popt,[],2);
			% perform line search
			h0 = 1;
			[fopt Popt_ h] = line_search(@(dPf) fun(Pl,Tl,dPf,fdx), Popt-Pl(fdx,:), 0, h0, [], [], maxit);

			% in rare cases a point can move further than it's closest neighbour and the triangulation may become inconsistent
			% therefore the step is limited to halve the distance to the closesest neihbour
			dx = bsxfun(@minus,Pl(fdx,1),Pl(fdx,1)');
			dy = bsxfun(@minus,Pl(fdx,2),Pl(fdx,2)');
			l  = sqrt(dx.^2+dy.^2) + 1e7*eye(size(dx));
			lmin = min(l)';
			delta = hypot(Popt(:,1)-Pl(fdx,1),Popt(:,2)-Pl(fdx,2));
			h = min(0.5*min(lmin./delta),h);
			%bflag(jdx) = (0 == h);
			Hh(jdx) = h;
			% step
			Popt = (1-h)*Pl(fdx,:) + h*Popt;
			Popt = reshape(Popt,[],2);
			%shift back
			Popt  = bsxfun(@plus,Popt,obj.point(po,1:2));
			% write back coordinates
			obj.point(pdxg(fdx),1:2) = Popt;
		end % for jdx
		% break if there is no progress
		[min(Hh),max(Hh)]
		if (sum(Hh==0) == length(to))
			printf('Stopped at iteration %d because no further improvement without inserting points is possible\n',idx);
			break;
		end
		no_old = no;
	end % while no convergence
end % improve_angle_local

function f = fun(P,T,dPf,fdx)
	P(fdx,:) = P(fdx,:) + dPf;
	f = MMesh.objective_angle(P(:),T);
end

