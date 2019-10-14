% Fri 18 Nov 14:22:51 CET 2016
% Karl Kastner, Berlin
% TODO swtich between hexas and cubesplits
%
% generate_uniform_triangulation(n,L,x0)
% 
function obj = generate_uniform_triangulation(varargin)
	[P T] = triangulation_uniform(varargin{:});
	obj = MMesh(P,T);
	%obj.point = P;
	%obj.elem  = T;
	obj.edges_from_elements();
end

