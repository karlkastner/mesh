% Sun  6 Nov 15:25:31 CET 2016
% Karl Kastner, Berlin
% when the project flag set, ghost points are porjected to the boundary,
% the project flag is set for dual mesh generation
% the project flag is unset for application of the boundary condition
function obj = generate_ghost_elements(obj,project)
%	if (~obj.isa_triangulation())
	if (3 ~= size(obj.elem,2))
		error('Mesh must be a triangulation');
		return;	
	end
	if (nargin() < 2)
		project = false;
	end
	T = obj.elem;
	% TODO fetch only coordinates of bnd elements
	Xt = obj.elemX;
	Yt = obj.elemY;
	tn = obj.elem2elem();

	if (sum(tn(:) == 0) ~= obj.nbnd)
		warning('tneighbour not working properly')
	end

	Tg = [];
	Xg = [];
	Yg = [];

	% for each side
	left  = [3 1 2];
	right = [2 3 1];
	for idx=1:3
		% find elements without neighbours
		fdx = find(0 == tn(:,idx));

		% edge centre
		Xc = 0.5*(Xt(fdx,left(idx)) + Xt(fdx,right(idx)));
		Yc = 0.5*(Yt(fdx,left(idx)) + Yt(fdx,right(idx)));

		% ghost element point indices
		% TODO make ccw
		Tg = [Tg; obj.np+size(Tg,1)+(1:length(fdx))', T(fdx,left(idx)), T(fdx,right(idx))];
		
		% coordinate of ghost point
		if (project)
			Xg = [Xg; Xc];
			Yg = [Yg; Yc];
		else
			% TODO do not mirror but take ideal triangle with respective edge length
			% linear extrapolation (mirror)
			Xg = [Xg; 2*Xc - Xt(fdx,idx)];
			Yg = [Yg; 2*Yc - Yt(fdx,idx)];
		end
		
	end
	% append ghost points to the mesh
	obj.eidghost = obj.nelem + (1:size(Tg,1))';
	obj.elem(obj.eidghost,:) = Tg; %= [obj.elem; Tg];
	obj.pidghost = obj.np+(1:length(Xg))';
	obj.point(obj.pidghost,1:2) = [Xg,Yg];
end

