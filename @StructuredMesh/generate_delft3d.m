% Tue  5 Nov 20:05:15 +08 2019
% TODO move this to Delft3D class
function d3d = generate_delf3d(mesh, folder_, param, param_silent)

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

	mesh.bc = param.bc;

	% model properties
%	z00 = param.z00;
%	Q0 = param.Q0;
%	nn = param.nn;

	mkdir(d3d.folder);
	d3d.read_all(d3d.templatefolder());
	if (isfieldorprop(param,'base'))
		d3d.base = param.base;
	end
	d3d.mdf.set_filenames(d3d.base);
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
		error('here')
	end

	% roughness
	if (isnumeric(rgh))
		rgh = repmat(rgh,size(mesh.X));
	else
		rgh = feval(rgh,mesh.X,mesh.Y);
	end
	rgh = inner2outer(inner2outer(rgh,1),2);
	d3d.mesh.export_delft3d_rgh([d3d.folder,'/',d3d.base,'.rgh'],rgh);

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
	if (~isfieldorprop(param,'z0')  || isempty(param.z0))
		%param.Zeta0          = @(x,y) S0*y;
		%param.u0             = @(x,y) u0*ones(size(x));
		ini.Zeta0 = @(x,y) repmat(0,size(x));
	else
		ini.Zeta0 = param.z0;
		%ini.Zeta0 = @(x,y) interp1(obj.x,obj.zt(0),y,'linear','extrap')
	end
	% TODO move this decision to write ini
	if (~isfieldorprop(param,'u0') || isempty(param.u0))
		ini.u0    = @(x,y) repmat(0,size(x));
	else
		ini.u0    = param.u0;
		%@(x,y) interp1(obj.x,obj.ut(0),y,'linear','extrap');
		%ini.u0    = @(x,y) interp1(obj.x,obj.ut(0),y,'linear','extrap');
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
	if (param.bndisharmonic)
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
	if (param.bndisharmonic)
		bnd(bid).filetype = 'H';
	else
		bnd(bid).filetype = 'T';
	end
	end

	d3d.bnd = bnd;

	bid = 0;
	% values at open boundaries
	% TODO, this does currently fail when left and right boundaries are swapped
	if (param.bndisharmonic)
		%zs0 = param.zs0;
		%nf  = length(zs0);
		nf = size(mesh.bc,2);
		%
		bch = [];
		if (~isfieldorprop(param,'isddb') || ~param.isddb(1))
			bid = bid+1;
			% (tidal) frequency components of downstream water level
			for idx=1:nf
				bch(bid,idx).omega = (idx-1)*param.omega;
%				if (idx<2)
					% mean level or flow
				rhs = mesh.bc(bid,idx).rhs;
				if (isempty(rhs))
					rhs = 0;
				end
				bch(bid,idx).rhs = rhs;
					%zs0(idx);
%				else
%					% frequency components z+z' (note : do not multiply with 2 here)
%					bch(bid,idx).rhs = zs0(idx);
%				end
			
			% seasonal component
			if (   isfieldorprop(mesh,'bc') ...
			    && size(mesh.bc,1)>0 ...
			    && isfieldorprop(mesh.bc,'Qseason') )
				bch(1,nf+1).omega   = 2*pi/mesh.bc(2,1).Tseason;
				Q = mesh.bc(bid,1).Qseason;
				if (isempty(Q))
					bch(bid,nf+1).rhs   = 0;
				else
					bch(bid,nf+1).rhs   = mid(Q);
					bch(bid,nf+1).rhs   = 0.5*range(mesh.bc(bid,1).Qseason)*exp(1i*mesh.bc(bid,1).phase_season);
				end
			end
			end
		end % if isddb(1)

		if (~isfieldorprop(param,'isddb') || ~param.isddb(2))
			bid = bid+1;
	
			%nf = 2;
			%bch(1,2).omega = (2-1)*param.omega;

			for idx=1:nf
				% tidal components
				bch(1,idx).omega = (idx-1)*param.omega;
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
			    && isfieldorprop(mesh.bc,'Qseason') )
%			if (~isfieldorprop(mesh,'bc') ...
%				|| size(mesh.bc,1)<2 ...
%				|| ~isfieldorprop(mesh.bc(2,1),'Qseason'))
%				% mean flow
%				bch(bid,1).rhs     = param.Q0;
%			else	
				%idx                = nf+1; % size(mesh.bc,2)+1;
				% frequency of seasonal variation
				bch(1,nf+1).omega   = 2*pi/mesh.bc(2,1).Tseason;
				% mean flow
				bch(bid,1).rhs     = mid(mesh.bc(2,1).Qseason);
				% seasonal variation upstream
				bch(bid,nf+1).rhs   = 0.5*range(mesh.bc(bid,1).Qseason)*exp(1i*mesh.bc(bid,1).phase_season);
			end

%			for idx=2:nf
%				% tidal components are zero
%				bch(bid,idx).rhs = 0;
%			end
		end % if ~isddb(2)
		d3d.bch = bch;
	else % as bct
		% TODO check isddb
		% boundary condition
		if (0)
		bct = struct();
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
		bct(1).id       = 1;
		bct(1).type     = 'Waterlevel';
		bct(1).location = 'Outflow';
		bct(1).dt_d     = dt_bc;
		bct(1).time     = param.bc(1).t;
		bct(1).val      = param.bc(1).zs;
	
		% inflow boundary (upstream)
		bct(2).id       = 2;
		bct(2).type     = 'Discharge';
		bct(2).location = 'Inflow';
		bct(2).dt_d     = dt_bc; %1/24;
		bct(2).time     = param.bc(2).t;
		bct(2).val      = param.bc(2).Q0;

		%bct(2).time     = t; % ^[0,1/24,param.mdf.Tstop/1440];
	 			     % Q0*[1e-3,1,1]; 
		%S0_  = S0;
		%Cd_  = Cd(end);
		%Q0_t = discharge_step_response(t*86400,h0,w0,S0_,Cd_);
		%Q0_t = repmat(param.Q0,size(t)); 
		%bct(2).val      = Q0_t;
	
		d3d.bct = bct;
	end

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

	d3d.MorFac = param.MorFac;

	d3d.write_all();

	% TODO, move to write_all
	if (~isempty(param.sediment))
		hist = Histogram();
		hist.export_csv([d3d.folder,filesep,'gsd.csv'],[param.sediment.d_mm],[param.sediment.p]);
	end
end

