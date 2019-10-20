% Mon  5 Dec 10:05:49 CET 2016
%% edge mid-points
function [Pc, obj] = edge_midpoint(obj,fdx)
	if (nargin < 2)
		P1 = obj.point(obj.edge(:,1),:);
		P2 = obj.point(obj.edge(:,2),:);
	else
		P1 = obj.point(obj.edge(fdx,1),:);
		P2 = obj.point(obj.edge(fdx,2),:);
	end
	Pc = 0.5*(P1+P2);
end

