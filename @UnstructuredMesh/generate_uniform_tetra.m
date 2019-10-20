% Thu 11 Jan 15:27:44 CET 2018
% Karl Kastner, Berlin
%
%% uniformly tesselate a rhombic domain in 3D into tetrahedra
% TODO swtich between teras and cubes
function obj = generate_uniform_tetra(varargin)
	[P, T] = mesh_3d_uniform(varargin{:});
	obj = UnstructuredMesh(P,T);
	obj.edges_from_elements();
end

