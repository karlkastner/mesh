% Wed 30 Nov 14:44:09 CET 2016
% Karl Kastner, Berlin
%% get cross-sections for 1D elements
function [Xc, Yc, Fc, X, Y, Z] = cross_section(obj,fdx)
	if (nargin()<2)
		[e2 fdx] = obj.elemN(2);
	end

	elem = obj.elem(fdx,1:2);

	% values at vertices
	X    = obj.X;
	Y    = obj.Y;
	Z    = obj.Z;
	F    = obj.pval.rgh;
	W    = obj.pval.width;

	% transversal bottom slope
	if (isfield(obj.pval,'dz_dn'))
		dz_dn = obj.pval.dz_dn;
	else
		dz_dn = 0;
	end

	% values at 1d element end vertices
	Xe   = X(elem);
	Ye   = Y(elem);
	Ze   = Z(elem);
	Fe   = F(elem);
	We   = W(elem);
	dz_dne = dz_dn(elem);

	% values at 1d element mid points
	% TODO make this a functions like elemX
	Xc   = 0.5*(Xe(:,1)+Xe(:,2));
	Yc   = 0.5*(Ye(:,1)+Ye(:,2));
	Zc   = 0.5*(Ze(:,1)+Ze(:,2));
	Fc   = 0.5*(Fe(:,1)+Fe(:,2));
	Wc   = 0.5*(We(:,1)+We(:,2));
	dz_dnc   = 0.5*(dz_dne(:,1)+dz_dne(:,2));

%	We    = cvec(obj.width_1d(fdx));
%	Fc    = cvec(obj.friction_1d(fdx));
	%Zc    = obj.Z_1d(fdx);

%	Fc   = 0.5*(Fe(:,1)+Fe(:,2));
	dx   = Xe(:,2)-Xe(:,1);
	dy   = Ye(:,2)-Ye(:,1);
	l    = hypot(dx,dy);
	dx   = dx./l;
	dy   = dy./l;
	odx  = -dy;
	ody  =  dx;

	% rectangular cross section
	X = [Xc-0.5*odx.*Wc,Xc+0.5*odx.*Wc];
	Y = [Yc-0.5*ody.*Wc,Yc+0.5*ody.*Wc];
	Z = Zc*[1 1] + (dz_dnc.*Wc)*(0.5*[-1 +1]);
end % cross_section

