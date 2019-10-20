% Thu 22 Jun 10:18:52 CEST 2017
%% integrate a quantity val across the mesh
function [int, inte] = integrate_1d(obj,val)
	elem2 = obj.elemN(2);
	ne    = size(elem2,1);
	X     = obj.X;
	X     = X(elem2);

	% element length
	dx = X(:,2)-X(:,1);

	% integration matrix
	% Ai = (Ax2 - Ax2)*c
	Ai   = sparse([(1:ne)';(1:ne)'], double(elem2(:)), ...
				 0.5*[double(dx);double(dx)],ne,obj.np);

	% integrate per element
	inte = Ai*val;

	% integrate over all
	int = sum(inte);
end % integrate_1d

