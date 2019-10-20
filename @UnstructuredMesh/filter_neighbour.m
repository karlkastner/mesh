% Tue May  3 08:26:02 CEST 2016
%
%% apply a function on the values on connected vertices
%
function [g, obj] = filter_neighbour(obj, fun, f, depth)
	if (nargin() < 4)
		depth = [];
	end
	% direct neighbours until depth
	A = obj.vertex_connectivity(depth);

	% add diagonal (point itself)
	A = A + speye(size(A));
	A = logical(A);
	g = NaN(size(f));
	for idx=1:length(f)
		g(idx) = fun(f(A(:,idx)));
	end
end % filter neighbour

