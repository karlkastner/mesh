% So 14. Feb 16:13:13 CET 2016
% Karl Kastner, Berlin

function [mesh oname] = improve_smooth_insert(iname,oname)
	switch(iname(end-3:end))
	case {'.mat'}
		load(iname,'mesh');
	case {'.msh'}
		mesh  = UnstructuredMesh();
		timer = tic();
		mesh.import_msh(iname);
		printf('Import took %f seconds\n',toc(timer));
	otherwise
		error('here');
	end
	mesh.remove_empty_triangles();
	timer = tic();
	mesh.remove_isolated_vertices();
	printf('Point removal took %f seconds\n',toc(timer));
	mesh.remove_trisected_triangles();
	mesh.edges_from_elements();

	meta = mesh_metadata();

	%mesh.improve_smooth_insert(meta.solver,meta.sopt);
	maxiter  = []; % use default
	topoflag = []; % use default
	mesh.improve_iterative_relocate_insert(maxiter,topoflag,meta.solver,meta.sopt);

	acute = mesh.check_orthogonality();
	nobtuse = sum(~acute);
	l=mesh.edge_length();
	lmin = min(l);
	fprintf(1,'Minimum edge length %f\n',lmin);
	
	if (nargin() < 2)
		oname = [iname(1:end-4),'-improved-local-',num2str(nobtuse),'-',num2str(lmin),'.mat'];
	end

	save(oname,'mesh');

	% export delft 3d mesh
%	[osuf obase] = suffix(oname);
%	mesh.export_delft3d([obase,'_net.nc']);

	% export edges to GIS
%	mesh.export_shp([obase,'-edges.shp']);

end % improve_smooth_insert

