% Do 3. Dez 18:42:56 CET 2015
% Sa 13. Feb 23:29:16 CET 2016
% Karl Kastner, Berlin
%
%% connectivity matrix between vertices
%
% detph : until neighbours with distance d
function [v2v nn obj] = vertex_connectivity(obj,depth)
	if (nargin() < 2 || isempty(depth))
		depth = 1;
	end

	% direct neighbpors
	v2v = sparse(double(obj.edge(:,1)),double(obj.edge(:,2)), ...
			ones(obj.nedge,1),obj.np,obj.np);
	v2v = v2v+v2v';

	if (nargin() > 1)
		% neighbours until depth are given by matrix powers
		v2v = v2v^depth;
	end
	v2v = (v2v > 0);
	nn = full(sum(v2v,2));

if (0)
	% discrete gaussian
	if (nargin > 1)
		D=diag(sparse(1./sqrt(sum(A))));
		A_ = D*A*D;
		A_ = (A_^depth);
	end
end

end % vertex_connectivity

