% Mo 26. Okt 20:50:02 CET 2015
% Karl Kastner, Berlin
%
% export into delft3d n
%
function obj = export_delft3d(obj,filename)
	obj.remove_isolated_vertices();
	obj.edges_from_elements();

	base = filename;
	if (strcmp(base(end-5:end),'net.nc'))
		base = base(1:end-6);
		if ('_' == base(end))
			base = base(1:end-1);
		end
	end
	mshname = [base,'_net.nc'];
	rghname = [base,'_rgh.xyz'];

	% fetch data
	point = obj.point;
	edge  = obj.edge';
	elem  = obj.elem';
	bnd   = obj.bnd;
	elemX = obj.elemX;
	elemY = obj.elemY;
	elemZ = obj.elemZ;

	elemX = nanmean(elemX,2);
	elemY = nanmean(elemY,2);
	elemZ = nanmean(elemZ,2);

	% TODO make class member
	hasbnd = ~isempty(bnd);

	if (size(point,2) < 3)
		point(:,3) = obj.DELFT3D.MISVAL;
	end

	fdx = (0 == elem);
	elem(fdx) = obj.DELFT3D.CRS;

	% get dimensions
	% TODO make class member
	nNetNode		= size(point,1);
	nNetLink		= size(edge,2);
	nNetElem		= size(elem,2);
	%nNetCompLines		= 0;
	nNetElemMaxNode		= size(elem,1);
	nNetLinkPts		= size(edge,1);
	if (hasbnd)
		nBndLink        = length(bnd);
	end
	% determine the netlinttype
	edge = obj.edge;
	% default 2d
	NetLinkType = 2*ones(nNetLink,1);
	% determine 1d elemens (1d and 2d elements do not share vertices)
	[elem2 fdx]      = obj.elemN(2);
	% determine 1d vertices
	pdx  = zeros(obj.np,1);
	pdx(elem2(:)) = 1;
	edge_ = pdx(edge(:,1));
	edx  = (edge_ == 1);
	NetLinkType(edx) = 1;
	% determine end points
	pdx = (1 == accumarray(elem2(:),ones(prod(size(elem2)),1),[obj.np,1]));
	edge_ = max(pdx(edge(:,1)),pdx(edge(:,2)));
	edx  = (edge_ == 1);
	NetLinkType(edx) = 4;
	%obj.DELFT3D.EDGETYPE*ones(nNetLink,1));

	%nNetCompLineNode_1	?

	% open file (overwrite)
	if (exist(mshname,'file'))
		ncid = netcdf.create(mshname,'CLOBBER');
	else
		ncid = netcdf.create(mshname,'NOCLOBBER');
	end

	% dimensions
	dNetNode        = netcdf.defDim(ncid,'nNetNode',nNetNode);
	dNetLink        = netcdf.defDim(ncid,'nNetLink',nNetLink);
	dNetElem        = netcdf.defDim(ncid,'nNetElem',nNetElem);
	dNetElemMaxNode = netcdf.defDim(ncid,'nNetElemMaxNode',nNetElemMaxNode);
	dNetLinkPts     = netcdf.defDim(ncid,'nNetLinkPts',nNetLinkPts);

	if (hasbnd)
		dBndLink        = netcdf.defDim(ncid,'nBndLink',nBndLink);
	end

	% variable definition
	vNetNode_x   = netcdf.defVar(ncid,'NetNode_x','NC_DOUBLE',dNetNode);
	vNetNode_y   = netcdf.defVar(ncid,'NetNode_y','NC_DOUBLE',dNetNode);
	if (~isempty(obj.Z))
		vNetNode_z   = netcdf.defVar(ncid,'NetNode_z','NC_DOUBLE',dNetNode);
	end
	vNetLinkType = netcdf.defVar(ncid,'NetLinkType','NC_INT',dNetLink);
	vNetLink     = netcdf.defVar(ncid,'NetLink','NC_INT',[dNetLinkPts, dNetLink]);
	vcrs         = netcdf.defVar(ncid,'crs','NC_INT',[]);
	vNetElemNode = netcdf.defVar(ncid,'NetElemNode','NC_INT',[dNetElemMaxNode, dNetElem]);

	vFlowElem_xcc = netcdf.defVar(ncid,'FlowElem_xcc','NC_DOUBLE',dNetElem);
	vFlowElem_ycc = netcdf.defVar(ncid,'FlowElem_ycc','NC_DOUBLE',dNetElem);
	if (~isempty(elemZ))
		vFlowElem_zcc = netcdf.defVar(ncid,'FlowElem_zcc','NC_DOUBLE',dNetElem);
	end

	if (hasbnd)
		vBndLink = netcdf.defVar(ncid,'BndLink','NC_INT',dBndLink);
	end
	vprojected_coordinate_system = netcdf.defVar(ncid,'projected_coordinate_system','NC_INT',[]);

	% TODO, this is at the moment fixed to zone 49M
	C = {'name'                           , 'WGS 84 / UTM zone 49N';
	     'epsg'                           , 32649;
	     'grid_mapping_name'              , 'Unknown projected';
	     'longitude_of_prime_meridian'    , 0;
	     'semi_major_axis'                , 6378137;
	     'semi_minor_axis'                , 6.356752314245179e+06;
	     'inverse_flattening'             , 2.982572235630000e+02;
	     'proj4_params'                   , '+proj=utm +zone=49 +datum=WGS84 +units=m +no_defs ';
	     'EPSG_code'                      , 'EPSG:32649';
	     'projection_name'                , ' ';
	     'wkt'                            , ' ';
	};
	for idx=1:size(C,1)
		netcdf.putAtt(ncid,vprojected_coordinate_system,C{idx,1},C{idx,2});
	end

	netcdf.endDef(ncid)

	% projection attribute

	% data

	% vertex coordinates
	netcdf.putVar(ncid,vNetNode_x,point(:,1));
	netcdf.putVar(ncid,vNetNode_y,point(:,2));
	if (~isempty(obj.Z))
		netcdf.putVar(ncid,vNetNode_z,obj.Z);
	end
	% edges
	netcdf.putVar(ncid,vNetLinkType,NetLinkType);
	netcdf.putVar(ncid,vNetLink,edge');
	% check sum
	netcdf.putVar(ncid,vcrs,obj.DELFT3D.CRS);
	% elements
	netcdf.putVar(ncid,vNetElemNode,elem);
	% element centre cooridiantes
	netcdf.putVar(ncid,vFlowElem_xcc,elemX);
	netcdf.putVar(ncid,vFlowElem_ycc,elemY);
	if (~isempty(elemZ))
		netcdf.putVar(ncid,vFlowElem_zcc,elemZ);
	end

	if (hasbnd)
		netcdf.putVar(ncid,vBndLink,bnd);
	end

	% close file
	netcdf.close(ncid);

	% export 2D roughness
	if (isfield(obj.pval,'rgh'))	
		%write_xyz([dirname(name),filesep,obj.roughness_str],obj.X,obj.Y,obj.pval.rgh);
		write_xyz(rghname,obj.X,obj.Y,obj.pval.rgh);
	end

	% export 1d reaches
	[elem2 fdx] = obj.elemN(2);

	%fdx = find(fdx);
	if (~isempty(fdx))
		% get mid points of elements
		%[Xc Yc] = obj.element_midpoint(fdx);
		% get cross section geometry
		[Xc Yc Fc X Y Z] = obj.cross_section(fdx);

		DFM.export_cross_section_geometry(base,Xc,Yc,Fc,X,Y,Z);

	% if (~isempty(oname))
		[X Y] = obj.boundary_1d();
		base_  = basename(mshname);
	%	name_C = {'Sea_Kubu','Sea_Besar','Sea_Kecil','Upstream_Sanggau'};
		for idx=1:size(X,1)
			shp   = struct();
			shp.X = X(idx,:);
			shp.Y = Y(idx,:);
			% TODO extend pli in export_pli
			name  = sprintf([base,'-%02d.pli'],idx);
			DFM.export_pli(shp,name,base_);
		end
	%end

	end % export 1d profiles
end % export_delft3d


