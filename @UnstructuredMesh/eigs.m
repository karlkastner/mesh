% Mi 27. Jan 12:52:13 CET 2016
% Karl Kastner, Berlin
%
%% eigenvalues of the lapalcian on the mesh
%
function [V E obj] = eigs(obj,m,bc,verbose)
	if (nargin() < 4)
		verbose = false;
	end
	shift = sqrt(eps);
	opts = struct();
	opts.issym=1;

	% assemple Laplacian operator discretisation matrix
	int    = @int_2d_nc_3;
	%jmesh = Mesh_2d_java(mesh)
	obj.edges_from_elements();
	bnd    = obj.edge(obj.bnd,:);
	jmesh  = javaObject('Mesh_2d', obj.point, obj.elem, bnd);
	A      = assemble_2d_dphi_dphi_java(jmesh, [], int);
	% apply BC
	if (strcmp(lower(bc),'dirichlet'))
		% TODO use get functions of Mesh_java class
		[P_ T_ Bc_ Nm_] = get_mesh_arrays(jmesh);
		A = boundary_2d(A,[],Bc_);
	end

	% determine the m-lowest frequent eigenfunctions of the operator
	timer  = tic();
	[V E]  = eigs(A,m,shift,opts);
	if (verbose);
		printf('Eigenvalue computation %fs\n',toc(timer));
	end
end % eigs

