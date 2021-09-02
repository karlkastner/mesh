% Sat 23 May 21:31:44 +08 2020
% function obj = generate_meander_bend(obj,Rcm,alpha,w,h0,ah,ds,nn)
function obj = generate_meander_bend(obj,Rcm,alpha,T,w,nt,nn,varargin)
	[x, y, z, R] = meander_bend_idealized(Rcm,alpha,T,w,[nt,nn],varargin{:});
	obj.X = x;
	obj.Y = y;
	obj.Z = z;
	obj.extract_elements();
end

