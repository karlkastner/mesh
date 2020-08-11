% Sat 23 May 14:12:43 +08 2020
function [z,w] = tidal_funnel_idealized(x,yn,w0,wu,hu,Lw,Lx)
	w      = (w0-wu)*exp(-x/Lw) + wu;
	hx     = hu.*wu.^2./w.^2;
	h0y    = 1-1/2*(1+cos(4*pi*yn));
	huy    = 1/2*(1+cos(2*pi*yn));
	z      = -hx.*(exp(-x/Lw).*h0y + (1-exp(-x/Lw)).*huy);
end

