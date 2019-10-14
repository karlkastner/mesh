% Mo 26. Okt 20:30:13 CET 2015
% Karl Kastner, Berlin
%
% import mesh from Delft3d file ( {filanme}_net.nc )
%
% TODO import cross section geometry
%
function [nc obj] = import_delft3d(obj,arg)

	filename = arg;
	base = filename;
	if (strcmp(base(end-5:end),'net.nc'))
		base = base(1:end-6);
		if ('_' == base(end))
			base = base(1:end-1);
		end
	end
	mshname = [base,'_net.nc'];
	rghname = [base,'_rgh.xyz'];

%	if (isstr(arg))
%		filename = arg;
%	else
%		nc = arg;
%	end
	nc = nc_readall(filename);

	elem = [];
	link = [];
	bnd  = [];
	type = [];
	X    = [];
	Y    = [];
	Z    = [];

	if (isfield(nc,'mesh2d'))
		%
		% format since version 1.2
		%
	
		if (isfield(nc,'mesh2d_node_x'))
			X = nc.mesh2d_node_x;
		end
		if (isfield(nc,'mesh2d_node_y'))
			Y = nc.mesh2d_node_y;
		end
		if (isfield(nc,'mesh2d_node_z'))
			Z = nc.mesh2d_node_z;
		end
		if (isfield(nc,'mesh2d_face_nodes'))
			elem = nc.mesh2d_face_nodes;
		end
		% edges ?
		if (isfield(nc,'mesh2d_edge_nodes'))
			link = nc.mesh2d_edge_nodes';
		end
%                  mesh2d_edge_x: [66975x1 double]		% edge centre?
%                  mesh2d_edge_y: [66975x1 double]
%              mesh2d_edge_x_bnd: [2x66975 double]		% edge bnd ? makes no sense
%              mesh2d_edge_y_bnd: [2x66975 double]
%              mesh2d_edge_faces: [2x66975 double]		% edge coodinates?
%                  mesh2d_face_x: [41088x1 double]		% element centre?
%                  mesh2d_face_y: [41088x1 double]
%              mesh2d_face_x_bnd: [4x41088 double]		% bnd for each element? makes no sense
%              mesh2d_face_y_bnd: [4x41088 double]
%    projected_coordinate_system: -2147483647
	else
		%
		% format until version 1.0
		%
	
		% fetch node vertices
		if (isfield(nc,'NetNode_x'))
			X      = nc.NetNode_x;
		end
		if (isfield(nc,'NetNode_y'))
			Y      = nc.NetNode_y;
		end
		if (isfield(nc,'NetNode_z'))
			Z      = nc.NetNode_z;
		else
			Z = [];
		end
	
		% fetch edges (indices into x and y)
		if (isfield(nc,'NetLink'))
			link   = nc.NetLink';
		else
			link = [];
		end
		if (isfield(nc,'NetLinkType'))
			type = nc.NetLinkType;
		end
	
		% fetch elements (indices into x and y)
		if (isfield(nc,'NetElemNode'))
			elem   = nc.NetElemNode';
		else
			warning('Mesh contains no elements');
			elem = [];
		end
	
		% fetch boundaries (indices into link)
		if (isfield(nc,'BndLink'))
	 		bnd=nc.BndLink;
		else
			bnd = [];
		end
	end

	% DFM 1.2 does not store directly the elements
	% these are parsed here from the edges
	% TODO this does not yet 
	aflag = true;
	if (isempty(elem))
		elem = elements_from_edges(X,Y,double(link),type);
	end

	% matrices roated in newer meshes?
	siz = size(link);
	if (siz(2)>siz(1) && siz(2)>2)
		link=link';
	end

	siz=size(elem);
	if (siz(2)>6)
		elem=elem';
	end

	obj.point = [X Y Z];
	obj.elem  = elem;
	obj.edge  = link;	
	obj.bnd   = bnd';


	% export 2D roughness
	if (exist(rghname,'file'))
		%[dirname(filename),filesep,obj.roughness_str],'file'))
		[x y rgh] = read_xyz(rghname); %[dirname(filename),filesep,obj.roughness_str]);
		id = knnsearch([obj.X,obj.Y],[x y]);
		obj.pval.rgh = NaN(obj.np,1);
		obj.pval.rgh(id) = rgh;
	else
		fprintf(['Cannot open file ',rghname,' for reading\n'])
		%fprintf(['Cannot open file ',dirname(filename),filesep,obj.roughness_str,' for reading\n'])
	end

	% read cross section geometry
	base = filename(1:end-7);
	obj  = DFM.read_cross_section_geometry(base,obj);

	% TODO, extract reference time, if existing
	% seconds since 2013-01-01 00:00:00
	% {a.Variables(time).Attributes(units).Value}
    	% 'seconds since 2013-01-01 00:00:00'    'time'

	% TODO, extract coordinate projection
%	size(elem)
%	size(link)

end % import_delft3d

