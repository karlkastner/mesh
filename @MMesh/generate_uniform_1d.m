% Fri 18 Nov 15:19:21 CET 2016
% Karl Kastner, Berlin
%
% function obj = generate_uniform_1d(obj,n,L,x0,wfun,dfun)
% TODO make function adding more general (name,handle)
function obj = generate_uniform_1d(obj,n,L,x0,wfun,dfun,rghfun,dz_dnfun)
	if (nargin() < 1 || isempty(n))
		n = 100;
	end
	if (nargin() < 2 || isempty(L))
		L = 1;
	end
	if (nargin() < 3 || isempty(x0))
		x0 = 0;
	end

	[P T Bc]  = mesh_1d_uniform(n,L,x0(1));
	obj.point = [P,zeros(n,1)];
	obj.elem  = T;
	obj.edges_from_elements();

	% with
	if (nargin() > 4 && ~isempty(wfun))
		w = wfun(P);
		obj.pval.width = w;
	end

	% depth
	if (nargin() > 5)
		d = dfun(P);
		obj.point(:,3) = d;
	end

	% roughness
	if (nargin() > 6)
		rgh = rghfun(P);
		obj.pval.rgh = rgh;
	end

	% transversal slope
	if (nargin() > 7)
		dz_dn = dz_dnfun(P);
		obj.pval.dz_dn = dz_dn;
	end
	
	%  X=mesh.X; Y=mesh.Y; Z=mesh.Z; Xl=X;Xr=X; Yl=50*ones(size(Y)); Yr=-Yl; generate_cs_geometry('cs',X,Y,[Xl Xr],[Yl, Yr],[Z Z])
end

