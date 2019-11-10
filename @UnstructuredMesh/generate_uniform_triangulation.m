% Fri 18 Nov 14:22:51 CET 2016
% Karl Kastner, Berlin
%
%% uniformly tesselate a rectangular (2d) domain into triangles
% TODO swtich between hexas and cubesplits
% generate_uniform_triangulation(n,L,x0)
% 
function obj = generate_uniform_triangulation(varargin)
	[P, T] = mesh_2d_uniform(varargin{:});
	%[P, T] = triangulation_uniform(varargin{:});
	obj = UnstructuredMesh(P,T);
	%obj.point = P;
	%obj.elem  = T;
	obj.edges_from_elements();
end

