% Di 15. Mär 09:46:47 CET 2016
% Karl Kastner, Berlin
%	
%% smooth values on the mesh
function [val, A, obj] = smooth_val(obj,val,p,n,abstol)
	if (nargin() < 2)
		val = [];
	end

	if (nargin() < 3 || isempty(p))
		p = 1.0;
	end

	if (nargin() < 4 || isempty(n))
		n = 1;
	end

	if (nargin() < 5 || isempty(abstol))
		abstol = 0;
	end

	if (p<0 || p > 1)
		p = 1.0;
		warning('p is bound by [0 1], setting to 1\n');
	end

	% get connectivity matrix
	A = obj.vertex_to_vertex();

	% number of neighbours
	% TODO: first or second dimension?
	nn = sum(A,2);

	% normalise
	%A = diag(sparse(1./nn))*A;
	A = diag(sparse(1./nn))*A;

	% averaging matrix
	A = (1-p)*speye(size(A)) + p*A;

	% iteratively smooth
	if (~isempty(val))
		for idx=1:n
			val0 = val;
			val  = A*val;
			if (norm(val-val0,'inf') < abstol)
				break;
			end
		end % for idx
	end % if
end % function smooth_val

