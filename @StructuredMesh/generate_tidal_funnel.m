% Sat 23 May 14:12:43 +08 2020
% idealized tidal funnel
% along which transmissibility w*sqrt(h) = const
% and flow splits around mouth bar
% w0 : downstream width
% wu : upstream width
% h0 : upstream depth
% Lw : convergence length of width
% Lx : domain length
% n(1) : number of points along channel
% n(2) : number of points across channel
function [mesh,h0y,huy] = generate_tidal_funnel(obj,w0,wu,hu,Lw,Lx,n)
%	if (isempty(Lh))
%		Lh = 2*Lw;
%	end
	x      = linspace(0,Lx,n(1))';
	x      = repmat(x,1,n(2));
	yn     = linspace(-1/2,1/2,n(2));
	yn     = repmat(yn,n(1),1);

	[z,w] = tidal_funnel_idealized(x,yn,w0,wu,hu,Lw,Lx);

%	x      = repmat(x,1,n(2));
	y      = w.*yn;
	obj.X = x;
	obj.Y = y;
	obj.Z = z;
	obj.extract_elements();
end

