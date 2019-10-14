% Fr 29. Jan 15:00:31 CET 2016
% Karl Kastner, Berlin
function [f res f_C res_C fdx_C c_C iter] = interp_fourier_smooth(obj,x0,y0,f0,tdx,m,abstol,varargin)
        [fdx_C tdx_l] = obj.assign(tdx);
	conde = zeros(obj.length,1);

	% for each segment
	for idx=1:obj.length
		printf('Processing segment %d (%f)\n',idx,idx/obj.length);
		meshi = obj.mesh_A(idx);

		% TODO, there should be a distributed set-up and solver
		% joint mesh
		P  = meshi.point;
		E1  = meshi.elem;
		E   = E1;
		np = meshi.np;
		x0i = x0(fdx_C{idx});
		y0i = y0(fdx_C{idx});
		f0i = f0(fdx_C{idx});
		tdx_li = cvec(tdx_l(fdx_C{idx}));
		d = zeros(meshi.np,1);
		w = ones(meshi.np,1);
		mark = idx*ones(meshi.np,1);
		for jdx=rvec(meshi.sneighbour)
			P = [P; obj.mesh_A(jdx).point];
			% TODO replace boundary points by points in first set
			E2_ = obj.mesh_A(jdx).elem;
			E2 = obj.mesh_A(jdx).elem+np;
			% replace boundary point references of segment 2 with those of segment 1
			% TODO, this does not resolve in-between neighbour interfaces
			ia = obj.mesh_A(jdx).pinterface{idx};
			for kdx=1:size(ia,1)
	  		   fdx = (E2_ == ia(kdx,1));
			   E2(fdx) = ia(kdx,2);
			end
			%E2(ia(:,1)) = E1(ia(:,2));
			E = [E; E2];
			% the redundant points are stacked as well
			np = np + obj.mesh_A(jdx).np;
			% interface point indices
			%open_global = 
			% flat(meshi.interface{jdx});
			% open_local = ib;
			open_local = ia(:,1); %obj.mesh_A(jdx).elem(ia); %obj.mesh_A(jdx).ia{idx});
			%open_local  = obj.mesh_A(jdx).global2local(open_global);
			% compute the distance weights for smoothing transition to the next element
			di = obj.mesh_A(jdx).distance(open_local);
			fdx = isinf(di); di(fdx) = 0;
			w = [w; cos(0.5*pi*di/max(di)).^2];
			w(fdx) = 0;
			d = [d; di]; 
			% concatenate source points
			% source points are uniquely assigned to segments, so no
			% overlap resolution necessary
			f0i = [f0i; f0(fdx_C{jdx})];
			x0i = [x0i; x0(fdx_C{jdx})];
			y0i = [y0i; y0(fdx_C{jdx})];
			ne  = size(E,1);
			tdx_li = [tdx_li; cvec(tdx_l(fdx_C{jdx}))+ne];
			mark = [mark; jdx*ones(obj.mesh_A(jdx).np,1)];
		end % for jdx

		% new mesh
		mesh = MMesh(P,E);
		np0 = mesh.np;
		ddx = mesh.remove_lonely_points();
		w = w(ddx);
		if (Debug.LEVEL > Inf)
		figure(idx);
		clf();
		%scatter3(P(:,1),P(:,2),mark,[],mark,'filled');
		P(id,:) = [];
		scatter3(P(:,1),P(:,2),w,[],w,'filled');
		view(0,90);
		end
	
		% interpolate on the proxy mesh
		%f0i = w.*f0i;
		%w = ones(size(w));
                %[f  res V c Ai cdx tdx conde    ]
	        %[f_ res ~ ~ ~  ~   ~   conde(idx)] = mesh.interp_fourier(...
	        [f_, res, ~, c, ~,  ~,   ~,   iter(idx)] = mesh.interp_fourier(...
			 x0i, y0i, f0i, w, tdx_l(fdx_C{idx}), m, abstol, ...
	                                       varargin{:});
		% inverse permutation of function
		f      = NaN(np0,1);
		f(ddx) = f_;

		% inverse permutation of the residual
		%res = NaN(size(fdx_C{idx}));
		%res(ddx) = res_;

		% extract values assigned to this element
		f_C{idx}   = f(1:meshi.np);
		res_C{idx} = res(1:length(fdx_C{idx}));
		c_C{idx}   = c;
	end % for idx
	if (Debug.LEVEL > Inf)
		pause;
	end
	
	% back to global coordinates
	f   = obj.local2global(f_C);
	res = obj.local2global_(res_C,fdx_C,length(f0));
end % interp_fourier_smooth

