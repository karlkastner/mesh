% Do 3. Dez 18:42:56 CET 2015
% Sa 13. Feb 23:29:16 CET 2016
% Karl Kastner, Berlin
%
% connectivity of directly connected vertices
%
function [A obj] = vertex_distance(obj)
	l = obj.edge_length();
	A = sparse(double(obj.edge(:,1)),double(obj.edge(:,2)), ...
			l, obj.np,obj.np);
	A = A+A';
end % vertex_distance

