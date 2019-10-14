% Mi 11. Nov 11:15:41 CET 2015
% Karl Kastner, Berlin
%
% Laplacian smoothing of vertex coordinates,
% replace every point by the average coordinate of its neibghbours
%
% TODO this works only for triangles,
% for rectangles : should the opposit corner pull as well?
%
%- constrained optimisation
%	- objective function	sum (x - mu x_neighbour).^2
%	- hessian is sparse, second derivative only depends on neighbours
%	- constrains determined by (xjxj + yiyj)/(||x||||y||) > 0
%-> are for the current smoothing the final obtuse elements disjoint to the initial?
function obj = smooth2(obj,maxiter,reltol,abstol,p,constrained,verbose,bndorder)
	if (nargin() < 2)
		maxiter = 1;
	end
	if (nargin() < 3 || isempty(reltol))
		reltol = 1e-3;
	end
	if (nargin() < 4 || isempty(abstol))
		abstol = 1e-7;
	end
	if (nargin() < 5 || isempty(p))
		p = 1;
	end
	if (nargin() < 6 || isempty(constrained))
		constrained = false;
	end
	if (nargin() < 7 || isempty(verbose))
		verbose = false;
	end
	if (nargin() < 7 || isempty(bndorder))
		bndorder = 0;
	end
	
	% for preservation of 1d elements
	elem2 = obj.elemN(2);
	point_1d = obj.point(elem2(:),:);
%	Y_1d = obj.Y(elem2(:));

	% fetch
	elem = obj.elem;
	XY   = obj.point(:,1:2);
	bnd3 = obj.bnd3; %boundary_chain();
	
	% get connectivity matrix
	A = obj.vertex_to_vertex();

	% number of neighbours
	% TODO: first or second dimension?
	nn = sum(A,2); 

	% normalise
	A = diag(sparse(1./nn))*A;

	% averaging matrix
	A = (1-p)*speye(size(A)) + p*A;

	% iterate
	iter = 0;
	while (1)
		iter = iter+1;
		% save old coordinates
		XY0 = XY;

		% smooth - move points to average of its neighbours	
		XY = A*XY;
		%XY = (1-p)*XY + p*A*XY;

		% project to boundary
		g  = XY-XY0;
		g  = MMesh.project_to_boundary(g,XY0,bnd3,bndorder);
		XY = XY0+g;

		% restore acuteness	
		if (constrained)
			XY = MMesh.restore_acuteness(elem,XY,XY0,verbose);
		end
		g  = XY-XY0;
		ng = norm(g(:),'inf');
		if (verbose)
			fprintf('Iteration %d, change: %g\n',iter,ng);
		end
		if (1 == iter)
			ng0 = ng;
		else
			if (ng <= reltol*ng0)
				fprintf('Smoothing converged at iteration %d\n',iter);
				break;
			end
		end
		%ng/ng0
		if (ng < abstol)
			break;
		end
		if (iter >= maxiter)
			fprintf('Smoothing not continued as maximum number of iterations reached at iteration %d, %f\n',iter,ng/ng0);
			break;
		end
	end % while (1)

	obj.point(:,1:2) = XY;

	% restore 1d elements
	obj.point(elem2(:),:) = point_1d;
end % smooth2

