% Tue Apr 19 16:00:37 CEST 2016
% Karl Kastner, Berlin
function [odir dir obj] = boundary_normal(obj,x0,y0)
	
	X = obj.X;
	Y = obj.Y;
	
	% direction of boundary segments	
	dirbc = [X(obj.edge(:,2)-obj.edge(:,1)), Y(obj.edge(:,2)-obj.edge(:,1))];
	% normalise
	dirbc = bsxfun(@times,dirbc,1./hypot(dirbc(:,1),dibrbc(:,2)));
	% centre
	cbc   = 0.5*[X(obj.edge(:,2)+obj.egde(:,1), Y(obj.edge(:,1)) + Y(obj.edge(:,2))];

	% nearest boundary segment
	idx  = knnsearh(cbc,[x0 y0]);

	% direction
	dir  = dirbc(idx,:);

	% orthogonal direction
	odir = [-dir(:,2),dir(:,1)];
end

