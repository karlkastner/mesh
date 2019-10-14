% 2015-10-28 21:23:48.384681075 +0100
% Karl Kastner, Berlin
%
% generate a mesh from a polygon using gmsh
%
% inshp      : file name of shape file of preloaded shape file containing a polygon
% obase      : base of output file name
% resolution : struct containing default mesh resolution settings
% resfile_C  : file names of shape files, defining local resolution in polygonal regions
% opt        : options, see below
%
% this is a Static function
function mesh = generate_gmsh(inshp, obase, resolution, resfile_C, opt)
	%algo = 'del2d';
	algo = 'front2d';
	% parse options
	if (nargin() < 5 || isempty(opt))
		opt = struct();
	end
	if (isempty(obase))
		obase = tempname();
	end
	if (~isfield(opt,'smooth_1d'))
		opt.smooth_1d = true;
	end
	if (~isfield(opt,'resample_1d'))
		opt.resample_1d = false;;
	end
	if (~isfield(opt,'linemode'))
		error('here');
	end
	if (~isfield(opt,'remesh'))
		opt.remesh = true;
	end
	if (~isfield(opt,'gmsh'))
		opt.gmsh = [];
	end

	% output file name
	base    = obase;
	field_C = {'nw','max','default','min','ratio'};
	for idx=1:length(field_C)
		field = field_C{idx};
		if (isfield(resolution,field))
			switch (field)
			case {'nw'} % number of elements per width
				base = [base,sprintf('-%s-%05g',field,resolution.(field))];
			case {'ratio'} % maximum ratio between the length of neigbouring edges
				base = [base,sprintf('-%s-%05g',field,resolution.(field))];
			case {'min','max','default'} % edge length
				base = [base,sprintf('-%s-%05g',field,resolution.(field))];
			otherwise
				error('generate_gmsh');
			end % switch
		end % if isfield
	end % for idx
	base = regexprep(base,' ','_');

	geoname = [base, '.geo'];
	rawmshname = [base, '-raw.msh'];
	matname = [base, '.mat'];
	shpname = [base, '.shp'];
	posname = [base, '.pos'];
	mshname = [base, '.msh'];

	%
	% read input polygon to be meshed
	% 
	shp = Shp.read(inshp);

	% complete loops
	shp = Shp.close_polygon(shp);

	% make one feature
	shp = Shp.cat(shp,NaN);

	% apply local resolution settings from file
	shp = Shp.set_resolution(shp,resolution,resfile_C);
	
	% automatically determine resolution for selected points depeding on width
	if (any(shp.auto))
		printf('Automatically determining resolution from width\n');
		width              = Geometry.poly_width(shp.X,shp.Y);
		auto = struct();
		[auto.res auto.minres auto.maxres] = resfun(shp.X,shp.Y,width,nw,minres,maxres);
		shp.resolution(shp.auto) = auto.res(shp.auto);
		shp.minres(shp.auto)     = auto.minres(shp.auto);
		shp.maxres(shp.auto)     = auto(shp.auto);
	end

	% verify limits
	fdx = find(shp.minres > shp.maxres);
	if (~isempty(fdx))
		fprintf('Warning: minres > maxres, swapping limits');
		[shp.minres,shp.maxres]=swap(shp.minres,shp.maxres,fdx);
	end

	% apply limits
	shp.resolution = max(shp.resolution,shp.minres);
	shp.resolution = min(shp.resolution,shp.maxres);

	% smooth
	if (opt.smooth_1d)
		shp.resolution = limit_by_distance_1d(shp.X,shp.Y,shp.resolution,resolution.ratio);
	end

	shp  = Shp.set_geometry(shp,'Line');

	% downsample to save memory, only required for bndlayer-mode
	if (opt.resample_1d)
		shp = Shp.resample_2(shp);
		shp_res = shp.resolution;

		% export resampled polygon as shape file
		shp = rmfield_optional(shp,'Id'); 
		shp = rmfield_optional(shp,'jd'); 
		shp = rmfield_optional(shp,'resolution'); 
		shp = rmfield_optional(shp,'minres'); 
		shp = rmfield_optional(shp,'maxres'); 
		shp = rmfield_optional(shp,'auto'); 
		%shp.Geometry = 'Polygon';
		%shp.Geometry = 'Line';
		shp = Shp.set_geometry(shp,'Polygon');
		Shp.write(shp,shpname);
		shp.resolution = shp_res;
	end % is resample_1d

	% resample depending on width
	%if (isfield(resolution,'mode') && strcmp('auto',resolution.mode))
	%	shp = Shp.resample_width(shp,resolution,resfile_C,scale);
	%end

	% export resampled polygon as matlab file
	%fprintf('Exporting resampled polygon: %s\n',matname);
	%save(matname,'shp');

	% write geometry file
	printf('Exporting geometry file: %s\n',geoname);
	Shp.export_geo(shp, geoname, resolution, opt.linemode, opt.gmsh);
	%Shp.export_geo(shp, geoname, resolution, opt.linemode, opt.gmsh);

	% mesh the geometry file with gmsh
	system(['LD_LIBRARY_PATH= gmsh ', MMesh.gmshopt, ...
				' -2 ', ...
				' -algo ', algo, ...
				' -o ', rawmshname, ...
				' ', geoname]);

	% the initial mesh is non smooth, a smooth element size is defined
	% on the initial mesh and the mesh is regenerated
	if (opt.remesh)
		fprintf('Remeshing\n');
		mesh = MMesh();
		mesh.import_msh(rawmshname);
		%mesh.remove_isolated_vertices();
		%mesh.edges_from_elements();

		% add bounding box
		xy = bounding_box([mesh.X,mesh.Y]);
		X = [mesh.X; xy(1,1); xy(1,1); xy(2,1); xy(2,1)];
		Y = [mesh.Y; xy(1,2); xy(2,2); xy(1,2); xy(2,2)];
		elem = delaunay(X,Y);
		mesh = MMesh([X,Y],elem);
		mesh.edges_from_elements();

		% nearest neighbour interpolation of edge length to boundary points
		fdx        = isfinite(shp.X);
		id = knnsearch(mesh.point(:,1:2),[cvec(shp.X(fdx)) cvec(shp.Y(fdx))]);
		res=max(shp.resolution(fdx))*ones(mesh.np,1);
		res(id) = shp.resolution(fdx);
%		interp     = TriScatteredInterp([cvec(shp.X(fdx)) cvec(shp.Y(fdx))],cvec(shp.resolution(fdx)),'nearest');
%		res        = resolution.default*ones(mesh.np,1);
%		bnd1       = mesh.bnd1;
%		res(bnd1)  = interp([mesh.X(bnd1),mesh.Y(bnd1)]);
		% limit relative growth of edge length to ensure smoothness
		res = mesh.limit_by_distance(res,resolution.ratio);
		% reexport the initial mesh with desired local resolution
		mesh.export_pos(posname,res);
		system(['LD_LIBRARY_PATH= gmsh ', MMesh.gmshopt, ...
						' -2 ', ...
						' -algo ',  algo,...
					        ' -bgm ', posname, ...
						' -o ', mshname, ...
						' ', geoname ]);
	end % if (remesh)

	% load the mesh file
	if (nargout() > 0)
		mesh = MMesh();
		mesh.import_msh(mshname);
	end

	% the gmsh output contains the points of the input polygon
	% thse are not part of the mesh and have to be removed
%	mesh.remove_isolated_points(mshname);	
%	mesh.export_msh(mshname);
end % generate_gmsh()

