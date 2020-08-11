% Sat 23 May 21:31:44 +08 2020
function obj = generate_meander_bend(obj,Rcm,alpha,w,h0,ah,ds,nn)
	nt = round(2*pi*Rcm/ds);
	[x, y, z, R] = meander_bend_idealized(Rcm,alpha,w,h0,ah,[nt,nn]);
%	generate_from_centreline(obj,X0,Y0,W0,dS,nn)
%	obj.generate_from_centreline(xy(:,1),xy(:,2),w,ds,nn);
	obj.X = x;
	obj.Y = y;
	obj.Z = z;
	obj.extract_elements();
end

