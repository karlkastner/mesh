% Thu 29 Sep 19:33:22 CEST 2016
% Karl Kastner, Berlin
%
%% improve mesh by smoothing following by uniform refinement
%
function [quality obj] = improve_smooth_uniformly_refine(obj,maxiter,topoflag,show)
	if (nargin() < 2 || isempty(maxiter))
		maxiter = 5;
	end
	if (nargin() < 4)
		show = false;
	end
	if (show)
		figure(100);
		clf
	end
	clear quality;
	iter = 0;
	while (1)
		iter = iter+1;
		printf('Mesh improvement outer iteration step %d\n',iter);

		o = obj.check_orthogonality();

		namedfigure(iter,'Before smoothing');
		clf()
		trisurf(obj.elem,obj.point(:,1),obj.point(:,2),[],double(~o),'edgecolor','k');
		hold on;
		X  = obj.elemX;
		Y = obj.elemY;
		plot(X(~o,:),Y(~o,:),'.r');
		view(0,90);
		axis equal

		fprintf('Number of obtuse elements before relocating %d\n',sum(~o));

		% improve the mesh quality by relocating the vertices
		%obj.improve_global2();
		obj.smooth2(100);

		% mesh quality statistics
		%flag  = ~(obj.check_orthogonality());
		quality(iter) = obj.statistics();

		nobtuse = quality(iter).nobtuse;
		fprintf('Iteration %d, %d elements, %d vertices, %d obtuse elements (%g%%)\n', iter, obj.nelem, obj.np, nobtuse, nobtuse./obj.nelem);

		if (show)
			% plot mesh, highlighting obtuse elements
			figure(iter);
			clf();
			opt          = struct();
			opt.edges    = true;
			opt.boundary = true;
			obj.plot(double(flag),opt);
			hold on
			axis equal

			% mark highly connected elements
			A   = obj.vertex_to_vertex();
			pdx = find(sum(A) > 7);
			plot(obj.X(pdx),obj.Y(pdx),'r.');
		
			namedfigure(100,'Mesh quality');
			%subplot(2,2,1)
			%[h x] = hist(angle(:));
			%n     = length(angle);
			%N(iter,2) = N(iter,1)/n;
			%h = h/n;
			%plot(x,h,'o');
			%hold on
			%title('Angle PDF');		

			subplot(2,2,1);
			Xall = (0:180);
			Yall = kernel1d(Xall,flat(stat(idx).angle.val));
			plot(Xall,Yall);
			%plot(sort(angle),(1:n)/(n+1))
			hold on;
			title('Angle PDF');

			subplot(2,2,2);
			Xmax = (60:180);
			Ymax = kernel1d(Xmax,stat(idx).angle.max);
			plot(Xmax,Ymax);
			hold on
			set(gca,'colororderindex',get(gca,'colororderindex')-1);
			Xmin = (0:60);
			Ymin = kernel1d(Xmin,stat(idx).angle.min);
			plot(Xmin,Ymin);
			%n = length(max_angle);
			%plot(sort(max_angle),(1:n)/(n+1))
			title('Max and Min Angle CDF');

			%subplot(2,2,4)
			%n = length(max_angle);
			%plot(sort(max_angle),(1:n)/(n+1))
			%hold on
			%title('Max Angle CDF');
		end % if show

		if (0 == sum(flag))
			printf('Converged to mesh without obtuse elements');
			break;
		end
		if (iter >= maxiter)
			break;
		end
		% uniformly refine the mesh
		obj = obj.refine();
		if (topoflag)
			obj.improve_topology();
		end

		end % for iter
end % function_improve_smooth_uniformly_refine

