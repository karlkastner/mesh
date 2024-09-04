% Tue  5 Nov 20:05:15 +08 2019
% TODO move this to Delft3D class
function d3d = generate_delf3d(mesh, folder_, param, param_silent, write)

	% note that time step in d3d is given in minutes (!)
	% TODO no magic numbers
	itdate  = '2020/01/01';
	tratype = 103;

	param = copyfields_deep(param_silent,param);

	d3d        = Delft3D();
	[folder,hfolder] = folder_name_from_parameters(folder_, param, true);
	
	if (~isfield(param,'naming'))
		param.naming = 'plain';
	end
	
	switch (param.naming)
	case {'hash'}
%	if (isfieldorprop(param,'hash') && param.hash)
		d3d.folder = hfolder;
%	end
	case {'plain'}
		d3d.folder = folder_;
	otherwise
		d3d.folder = folder;
	end
       
	if (isfieldorprop(param,'dt_bc'))
		dt_bc = param.dt_bc;	
	else
		dt_bc   = 1/24;  % days
	end

	if (~isfieldorprop(param,'nz'))
		param.nz = 1;
	end

	if (isfield(param,'bc'))
	mesh.bc = param.bc;
	end

	% model properties

	d3d.read_all(d3d.templatefolder());
	if (isfieldorprop(param,'runid'))
		d3d.runid = param.runid;
	end
	d3d.mdf.set_filenames(d3d.runid);
	% d3d.tratype = param.tratype;
	d3d.itdate  = datenum(itdate);
	d3d.tratype = tratype;

	d3d.mesh = mesh;
%	d3d.mesh.generate_rectangle(  0.5*[1,-1] ...
%			            , Xi + sqrt(eps) ...
%				    , [nn(1),nn(2)]);
	

	
%	d3d.mesh.Y = 

	% extend domain by fading out elements (2e6m)
	Y  = d3d.mesh.Y;
	X  = d3d.mesh.X;
	x  = Y(1,:);
	dx = x(end)-x(end-1);

	% TODO not good, make parameter 'Chezy/Manning and take value and type'
	if (isfield(param,'Manning'))
		param.mdf.Roumet = 'M';
		rgh = param.Manning;
	elseif(isfield(param,'Chezy'))
		param.mdf.Roumet = 'C';
		rgh = param.Chezy;
	else
		error('Roughness coefficient not defined')
	end

	% roughness
	if (isnumeric(rgh))
		rgh = repmat(rgh,size(mesh.X));
	else
		rgh = feval(rgh,mesh.X,mesh.Y);
	end
	rgh = inner2outer(inner2outer(rgh,1),2);
	d3d.rgh = rgh;
	%d3d.mesh.export_delft3d_rgh([d3d.folder,'/',d3d.runid,'.rgh'],rgh);

	if (isnumeric(param.zb))
		zb = repmat(param.zb,size(mesh.X));
	else
		zb = feval(param.zb,mesh.X,mesh.Y);
	end
	d3d.mesh.Z = zb;

	% set bed level
	h0  = -zb(1);

	nn = mesh.n;
	% TODO, set automatically after generation
	d3d.mdf.mdf.dat.MNKmax  = sprintf(' %d %d %d',[nn(2)+1,nn(1)+1,param.nz]);

	% initial condition
	ini = struct();

	% initial condition
	if (isfieldorprop(param,'z0'))
		ini.Zeta0 = param.z0;
	end

	if (isfieldorprop(param,'u0'))
		ini.u0    = param.u0;
	end

	d3d.ini = ini;

	if (isfield(param,'inicomp') && ~isempty(param.inicomp))
		for idx=1:length(param.inicomp)
			d3d.inicomp{idx}.SedBed = @(x,y) param.inicomp{idx}(x,y,[param.sediment.p]);
		end
	end
                                                       
	% configure mdf
	param.mdf.Flrst = param.mdf.Tstop;
	d3d.mdf.set(param.mdf);

	b     = sqrt(2);
	if (isfieldorprop(param,'sz'))
		sz = param.sz;
	else
		sz = 1;
	end
	s     = mesh1([1,0],param.nz+1,sz.^-(param.nz+1));
	ds    = diff(s);

	%ds    = b.^(opt.nz-1:-1:0);
	% layer thickness is passed through delf3d as percent
	ds    = 100*ds/sum(ds);
	Thick = sprintf('            %8e\n',ds);
	%repmat(100./opt.nz,opt.nz,1));
	d3d.mdf.mdf.dat.Thick = Thick;

	d3d.mor.set(param.mor);
%	d3d.mdf.set(param.mdf);
	% crashes otherwise
	%d3d.mdf.mdf.dat.Filsed = '##'

	% TODO, set function
%	if (isfield(param,'Rettis'))
%		Rettis = sprintf('            %g\n',param.Rettis);
%		d3d.mdf.mdf.dat.Rettis = Rettis;
%	end
%	if (isfield(param,'Rettib'))
%	Rettib = sprintf('            %g\n',param.Rettib);
%		d3d.mdf.mdf.dat.Rettis = Rettib;
%	end

	% location of downstream boundary
	bnd = [];
	bid            = 0;
	
	if (~isfieldorprop(param,'isddb') || ~param.isddb(1))
	bid = bid+1;
	bnd(bid).name  = 'Outflow';
	bnd(bid).left  = [1,2];
	bnd(bid).right = [1,nn(1)];
	% TODO, make dependend z,q
	bnd(bid).type  = 'Z';
	if (param.bndisharmonic(bid))
		bnd(bid).filetype = 'H';
	else
		bnd(bid).filetype = 'T';
	end
	end

	if (~isfieldorprop(param,'isddb') || ~param.isddb(2))
	% location of upstream boundary
	bid = bid+1;
	bnd(bid).name  = 'Inflow';
	bnd(bid).left  = [nn(2)+1,2];
	bnd(bid).right = [nn(2)+1,nn(1)];
	bnd(bid).type  = 'T';
	if (param.bndisharmonic(bid))
		bnd(bid).filetype = 'H';
	else
		bnd(bid).filetype = 'T';
	end
	end

	d3d.bnd = bnd;

	bid = 0;
	% values at open boundaries
	%if (param.bndisharmonic)
		%zs0 = param.zs0;
		%nf  = length(zs0);
		nf = size(mesh.bc,2);
		%
		bch = [];
		% left boundary
		if (param.bndisharmonic(1))
		if (~isfieldorprop(param,'isddb') || ~param.isddb(1))
			bid = bid+1;
			% (tidal) frequency components of downstream water level
			for idx=1:nf
				if (isscalar(param.omega))
					bch(bid,idx).omega = (idx-1)*param.omega;
				else
					bch(bid,idx).omega = param.omega(idx);
				end
					% mean level or flow
				rhs = mesh.bc(bid,idx).rhs;
				if (isempty(rhs))
					rhs = 0;
				end
				bch(bid,idx).rhs = rhs;
			end
			
			% seasonal component
			if (   isfieldorprop(mesh,'bc') ...
			    && size(mesh.bc,1)>0 ...
			    && isfieldorprop(mesh.bc(bid,1),'Qseason') )
				% frequency of seasonal variation
				bch(1,nf+1).omega   = 2*pi/mesh.bc(2,1).Tseason;
				Q = mesh.bc(bid,1).Qseason;
				if (isempty(Q))
					bch(bid,nf+1).rhs   = 0;
				else
					% mean flow
					bch(bid,nf+1).rhs   = mid(Q);
					% seasonal variation
					bch(bid,nf+1).rhs   = 0.5*range(mesh.bc(bid,1).Qseason)*exp(1i*mesh.bc(bid,1).phase_season);
				end
			end
		end % if isddb(1)
		end % isharmonic

		% right boundary
		if (param.bndisharmonic(2))
		if (~isfieldorprop(param,'isddb') || ~param.isddb(2))
			bid = bid+1;
	
			for idx=1:nf
				% tidal components
				if (isscalar(param.omega))
					bch(bid,idx).omega = (idx-1)*param.omega;
				else
					bch(bid,idx).omega = param.omega(idx);
				end
				% bch(1,idx).omega = (idx-1)*param.omega;
				%bch(bid,idx).rhs = mesh.bc(bid,idx).rhs;
				rhs = mesh.bc(bid,idx).rhs;
				if (isempty(rhs))
					rhs = 0;
				end
				bch(bid,idx).rhs = rhs;
			end
	
			% upstream discharge with seasonal variation
			if (isfieldorprop(mesh,'bc') ...
			    && size(mesh.bc,1)>0 ...
			    && isfieldorprop(mesh.bc(2,1),'Qseason') )
				% frequency of seasonal variation
				bch(1,nf+1).omega   = 2*pi/mesh.bc(2,1).Tseason;
				% mean flow
				bch(bid,1).rhs     = mid(mesh.bc(2,1).Qseason);
				% seasonal variation
				bch(bid,nf+1).rhs   = 0.5*range(mesh.bc(bid,1).Qseason)*exp(1i*mesh.bc(bid,1).phase_season);
			end

%			for idx=2:nf
%				% tidal components are zero
%				bch(bid,idx).rhs = 0;
%			end
		end % if ~isddb(2)
		end % bndisharmonic(2)
	
		d3d.bch = bch;
%	else % as bct

		bct = struct();
		bid = 0;
		% TODO make type element of bc, harmonic or timeseries
		if (~param.bndisharmonic(1))
		bid = bid+1;
		% TODO check isddb
		% boundary condition
		if (0)
		t   = (0:dt_bc:param.mdf.Tstop/1440)';
		z   = param.zs0*ones(size(t)); % + real(z10*exp(1i*param.omega*t*86400));
		dx  = Y(1,end)-Y(1,end-1)
		S0  = (zb(1,end)-zb(1,end-1))./dx
		%w0  = w0(end)
	
		g = Physics.gravity;
		c = sqrt(g*h0);
		% ignore flow vel, for time being
		% c*dt < dx
		dt_max = dx/c;
		fprintf('dt_max %f\n',dt_max);
		end	


		% TODO merge bct and bnd -> consistency has to be checked when reading of files
		% TODO assign id automatically by index
		% "name" is a redundant field
		% "type" can be determined outomatically
	
			% outflow boundary (downstream)
			bct(bid).id       = 1;
			bct(bid).type     = 'Waterlevel';
			bct(bid).location = 'Outflow';
			bct(bid).dt_d     = dt_bc;
			bct(bid).time     = param.bc(1).t;
			bct(bid).val      = param.bc(1).zs;
		end
	
		if (~param.bndisharmonic(2))
		bid = bid+1;
		% inflow boundary (upstream)
		bct(bid).id       = 2;
		bct(bid).type     = 'Discharge';
		bct(bid).location = 'Inflow';
		bct(bid).dt_d     = dt_bc; %1/24;
		bct(bid).time     = param.bc(2).t;
		bct(bid).val      = param.bc(2).Q0;
		end
	
		%bct(2).time     = t; % ^[0,1/24,param.mdf.Tstop/1440];
	 			     % Q0*[1e-3,1,1]; 
		%S0_  = S0;
		%Cd_  = Cd(end);
		%Q0_t = discharge_step_response(t*86400,h0,w0,S0_,Cd_);
		%Q0_t = repmat(param.Q0,size(t)); 
		%bct(2).val      = Q0_t;
	
		d3d.bct = bct;
	% end % of bndisharmonic

	% TODO should go into set_fractions
%	if (~isfieldorprop(param.sediment,'c0'))
%		d3d.set_fractions([] ...
%				, [] ...
%				, [] ...
%				, [] ...
%				 );
%	else

	% void
	for idx=1:length(param.sediment)
		if (isempty(param.sediment(idx).p))
			param.sediment(idx).p = 1;
		end
	end

	if (isfield(param,'IniSedThick'))
		IniSedThick = param.IniSedThick;
	else
		IniSedThick = NaN;
	end
	if (isfield(param,'T_C'))
		T_C = param.T_C;
	else
		T_C = NaN;
	end

	if (~isfield('salinity','param'))
		param.salinity = [];
	end
		
	d3d.set_fractions(param.sediment ...
			, param.salinity ...
			, IniSedThick ...
			, T_C ...
			 );

	d3d.default_bcc(param.sediment,param.salinity,dt_bc);
%	end

	if (     isfieldorprop(mesh,'bc') ...
	     &&  length(mesh.bc) > 1 ...
             &&  isfieldorprop(mesh.bc(2),'c') ...
	     && ~isempty(mesh.bc(2).c) )
		val           = interp1(mesh.bc(2).c.t, mesh.bc(2).c.val,...
						     d3d.bcc(2).time,'linear');
		%d3d.bcc(2).t   = mesh.bc(2).c.t;
		% TODO, this assumes, that the clay fraction is the first fraction
		d3d.bcc(1).val(:,1) = val; %param.cmud0;
		d3d.bcc(2).val(:,1) = val;
		%mesh.bc(2).c.val;
	end

	if (~isempty(param.salinity))
		for idx=1:length(param.salinity.bc)
		val           = interp1(param.salinity.bc(idx).t, param.salinity.bc(idx).val,...
						     d3d.bcc_sal(idx).time,'linear');
		d3d.bcc_sal(idx).val = val;
		end
	end

	if (isfield(param,'MorFac'))
	d3d.MorFac = param.MorFac;
	end

	if (nargin()<5  || write)

	d3d.write_all();

	% TODO, this is redundant to the sed-file and can be extracted from there
	if (~isempty(param.sediment))
		hist = Histogram();
		hist.export_csv( [d3d.folder,filesep,'gsd.csv'] ...
                        	,[param.sediment.d_mm] ...
				,[param.sediment.p] ...
				);
	end
	end
end

