% 2015-11-10 13:10:18.538662054 +0100
% Karl Kastner, Berlin
%
%% euclidean edge length
%
function [l obj] = edge_length(obj,fdx)
	if (nargin()<2)
		fdx = true(obj.nedge,1);
	end
	P = obj.point;
	E = obj.edge(fdx,:);
	l = hypot(P(E(:,1),1) - P(E(:,2),1), P(E(:,1),2) - P(E(:,2),2) );
end % edge_length

