% Di 3. Nov 12:15:17 CET 2015
% Karl Kastner, Berlin
%
%% iteratively improve the mesh by smoothing
%
function [mesh] = iterate_smooth2(mesh,cflag,maxiter)

	if (nargin() < 3)
		maxiter = inf;
	end
	dl_rel_max_min = 0.01;
	dl_rel_max = inf;
	sno_old = inf;
	minimprove = -inf;
	idx0   = 0;
	idx    = 0;
	P_old  = mesh.point();
	while (true)
		idx=idx+1;
		ortho  = mesh.check_orthogonality();
		northo = ~ortho;
		sno    = sum(northo);
		l      = mesh.edge_length();
		if (idx > idx0+1)
			dl = l - l_old;
			dl_rel = dl./l_old;
			fdx = find(abs(dl_rel) > 1);
			e2e = flat(mesh.edge2elem(fdx,:));
			e2e = e2e(e2e>0);
			col = zeros(mesh.nelem,1);
			col(e2e(:)) = 1;
			% mark all edges that changed by more than its own length
%			figure(1)
%			clf();
%			trisurf(mesh.elem,mesh.X,mesh.Y,[],col,'edgecolor','k');
%			hold on;
%			plot(mesh.X,mesh.Y,'.');
%			view(0,90); axis equal
%			figure(2);
%			clf();
%			trisurf(mesh.elem,P_old(:,1),P_old(:,2),[],col,'edgecolor','k');
%			hold on
%			plot(P_old(:,1),P_old(:,2),'r.');
%			view(0,90); axis equal
%			size(e2e)
%			pause
			
%			mesh.plot();
%			mesh.point = P_old;
			
%			mesh.
			
			printf('Smoothing iteration step %d\n',idx);
			printf('Relative change in edge length l1 %f l2 %f linf %f\n', ...
			norm(dl_rel,1)/length(l), ...
			norm(dl_rel,2)/sqrt(length(l)), ...
			norm(dl_rel,inf));
			dl_rel_max = max(abs(dl_rel));
			%northo0 = northo;	
		else
			printf('Initial mesh:\n');
			printf('Number of elements: %d\n',mesh.nelem);
			%printf('Number of obtuse elements remaining from initial mesh: %d\n',sum(northo.*northo0));
			%printf('Fraction of obtuse elements remaining from initial mesh: %f wr to initial mesh\n',sum(northo.*northo0)./sum(northo0))
			%printf('Fraction of obtuse elements remaining from initial mesh: %f wr to current mesh\n',sum(northo.*northo0)./sum(northo))
		end
		printf('Nubmer of obtuse elements: %d\n',sno);
		printf('Fraction of obtuse elements: %f\n',sno/mesh.nelem);

		% stopping criteria
		if (0 == sno)
			printf('Iteration converged.\n');
			break;
		end
		if (dl_rel_max < dl_rel_max_min)
			printf('Iteration stopped because relative change was less than the tolerance\n');
			break;
			%pause
		end
		if (sno - sno_old < minimprove)
			printf('Iteration stopped before converging, because number of obtuse elements did not change during the last step\n');
			break;
		end
		if (idx > maxiter)
			printf('Iteration stopped before converging, because maximum number of iterations was reached.\n');
		end
		l_old   = l;
		sno_old = sno;
		mesh.smooth2(cflag);
	end
end

