% Mon 28 Nov 16:44:58 CET 2016
%% convert 1D mesh to 2D mesh
% TODO also return 1d-2d connections and bifurcations
function [X, Y, obj] = boundary_1d(obj,p,q)

	% distance to last point as factor of element length
	if (nargin() < 2 || isempty(p))
		p = 0.1;
	end

	% width of cross section as factor of element length
	if (nargin() < 3 || isempty(q))
		q = 1;
	end

	if (nargin() < 4)
		oname = [];
	end
	
	% 1D elements
	[elem2, edx] = obj.elemN(2);

	% 1D bnd points
	[u, n] = count_occurence(elem2(:));
	bnd1 = u(1==n);

	X       = obj.X;
	Y       = obj.Y;
	% TODO, only works for triangles
	elX     = obj.elemX();
	elY     = obj.elemY();

	% determine end points that are not connected to the 2d mesh
	flag = true(length(bnd1),1);
	if (~isempty(obj.elemN(3)))
	for idx=1:length(bnd1)
		% TODO do this only for tri, not lines and rects
		in = Geometry.inTriangle(elX,elY,X(bnd1(idx)),Y(bnd1(idx)));
		flag(idx) = none(in);
	end
	end
	bnd1 = bnd1(flag);
	
	edx = [];
	% find bnd elements
	for idx=1:length(bnd1)
		edx(idx,1) = find(any(bnd1(idx) == elem2,2));
	end
	bnd12 = elem2(edx,:);

	% reorder, boundary point first
	fdx = (bnd12(:,1) ~= bnd1);
	bnd12(fdx,2) = bnd12(fdx,1);
	bnd12(fdx,1) = bnd1(fdx);

	Xbnd12 = X(bnd12);
	Ybnd12 = Y(bnd12);

	%sections=dir('*.pli');
	%for idx=1:sections
	%	bnd{idx} = Shp.import_pli(sections(idx).name);
	%end
	
	% inflow direction (along)
	dx = diff(Xbnd12')';
	dy = diff(Ybnd12')';
	l = hypot(dx,dy);
	dx = dx./l;
	dy = dy./l;

	% orthogonal direction (across)
	odx = -dy;
	ody =  dx;

	if (isfield(obj.pval,'width'))
		w = q*obj.pval.width(bnd12(:,1));
	else
		w = q*l;
	end
	
	% centre of boundary edge
	X = (1+p)*X(bnd12(:,1))-p*X(bnd12(:,2));
	Y = (1+p)*Y(bnd12(:,1))-p*Y(bnd12(:,2));
	%X = p*X(bnd12(:,1))+(1-p)*X(bnd12(:,2));
	%Y = p*Y(bnd12(:,1))+(1-p)*Y(bnd12(:,2));

	% left and right bank of boundary edge
	X = [X-0.5*w.*odx,X+0.5*w.*odx];
	Y = [Y-0.5*w.*ody,Y+0.5*w.*ody];

end % generate_1d_boundary

