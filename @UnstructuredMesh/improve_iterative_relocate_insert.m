% So 14. Feb 16:13:13 CET 2016
% Karl Kastner, Berlin
%
%% iteratively improve the mesh by inserting vertices and smoothing
%
function [quality obj] = improve_smooth_insert(obj,maxiter,topoflag,solver,sopt,show)
	cflag = true;

	if (size(obj.elemN(3),1) ~= obj.nelem)
		error('Mesh must contain triangles only, remove 1d elements and quadrilaterals first');
	end

	if (nargin() < 2 || isempty(maxiter))
%		maxiter = 5;
		maxiter = 100;
	end
	if (nargin() < 3 || isempty(topoflag))
		%topoflag = true;
		topoflag = false;
	end
	if (nargin() < 4 || isempty(solver))
		% TODO
	end
	if (nargin() < 5 || isempty(sopt))
		sopt = struct();
		sopt.ls_h = 1;
	end
	if (nargin() < 6)
		show = false;
	end

	bndorder = 1;
	nsmooth = 1000;

	clear quality;
	iter=0;
	while (1)
		iter=iter+1;
		printf('Mesh improvement outer iteration step %d\n',iter);

		o = double(obj.isobtuse());
		o(isnan(o)) = 0;

		namedfigure(iter,'Before smoothing');
		clf()
		trisurf(obj.elem,obj.point(:,1),obj.point(:,2),[],double(o),'edgecolor','k');
		hold on;
		X  = obj.elemX;
		Y = obj.elemY;
		plot(X(logical(o),:),Y(logical(o),:),'.r');
		view(0,90);
		axis equal

		fprintf('Number of obtuse elements before relocating %d\n',sum(o));

		% improve the mesh quality by relocating the vertices
		%obj.iterate_smooth2(cflag);
		%obj.improve_relocate_global_3();
		if (0)
			obj.smooth2(nsmooth);
		else
			ofun = @objective_cosa;                                                 
		        bndorder = 2;                                                           
		        solveropt.maxiter = 10;                                                 
		        obj.improve_relocate_global_3(ofun,solveropt,bndorder);
		end

		% mesh quality statistics
		%flag  = ~(obj.check_orthogonality());
		quality(iter) = obj.statistics();

		nobtuse = quality(iter).nobtuse;
		fprintf('Iteration %d, %d elements, %d vertices, %d obtuse elements (%g%%)\n', iter, obj.nelem, obj.np, nobtuse, nobtuse./obj.nelem);

if (0)
		o = double(obj.isobtuse());
		o(isnan(o)) = 0;

		namedfigure(1000+iter,'Before local improvement');
		clf()
		trisurf(obj.elem,obj.point(:,1),obj.point(:,2),[],double(o),'edgecolor','k');
		view(0,90);
		axis equal

		% improve each obtuse triangle locally
		fprintf('Number of obtuse elements before local improvement %d\n',sum(o));
		obj.improve_angle_local(solver,sopt);
end
		

		o = double(obj.isobtuse());
		o(isnan(o)) = 0;
		fprintf('Number of obtuse elements before insertion %d\n',sum(o));

		namedfigure(1000+iter,'Before insertion of new points');
		clf();
		trisurf(obj.elem,obj.point(:,1),obj.point(:,2),[],double(o),'edgecolor','k');
		hold on;
		X  = obj.elemX;
		Y = obj.elemY;
		plot(X(logical(o),:),Y(logical(o),:),'.r');
		view(0,90);
		axis equal
%		pause

		if (0 == sum(o))
			disp('Convergence');
			break;
		end

		% insert steiner points at elements that could not be further improved
		obj.split_unsmooth_edges();
%		obj.split_obtuse(logical(o));
%		obj.insert_steiner_points(logical(o))
%		obj.insert_mid_points(logical(o))
%		obj.edges_from_elements();

		if (topoflag)
			obj.improve_topology();
		end
%		obj.resolve_8_vertices();
%		obj.remove_quartered_triangles();

		if (iter >= maxiter)
			break;
		end
	end
end

