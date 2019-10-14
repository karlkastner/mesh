% Thu 11 Jan 15:27:44 CET 2018
% Karl Kastner, Berlin
% TODO swtich between teras and cubes
function obj = generate_uniform_tetra(varargin)
	%[P T B] = mesh_3d_uniform(varargin{:});
	[P T] = mesh_3d_uniform(varargin{:});
	obj = MMesh(P,T);
	%obj.point = P;
	%obj.elem  = T;
	obj.edges_from_elements();
end

