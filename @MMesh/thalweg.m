% Fri  5 Aug 14:33:33 CEST 2016
% TODO, use quadratic interpolation and steepest descend
% Known problems:
%	alternative pathes around islands
% 	path crosses itself
function [S id z] = thalweg(obj,xy0,isindex,z)
	if (nargin() < 4)
		z = obj.Z;
	end
	n_iter = 5;
	A = obj.vertex_connectivity();
	[S id] = path(obj,xy0,isindex);
	n = length(id);
	block = false(size(z));
	block(id) = true;

	for iterdx=1:n_iter
	for jdx=1:length(id)
		% search deepest neighbour, that is not the predecessor or successor
		nn     = find(A(:,id(jdx)));
		id_max = id(jdx);
		z_max  = z(id(jdx));
		for ndx=rvec(nn)
			if ( z(ndx) < z_max ...
			     && ~block(ndx) ... % ~= id(max(1,jdx-1)) ...
                             ... %&& ~block(ndx) ... %ndx ~= id(min(n,jdx+1)) ...
		        )
			id_max = ndx;
			z_max  = z(ndx);
			end
		end % for ndx
		block(id(jdx)) = false;
		block(id_max) = true;
		id(jdx) = id_max;
	end % for jdx
	end % for iterdx
	id = cvec(id);
	D = obj.vertex_distance();
	idD = sub2ind(size(D),id(1:end-1),id(2:end));
	dS = full(D(idD));
	S = [0;cumsum(dS)];
	z = z(id); 
end

