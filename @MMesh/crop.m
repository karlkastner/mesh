% Fri 27 May 09:10:59 CEST 2016
% Karl Kastner, Berlin
% 
% TODO this is redundant to cut
function obj = crop(obj,Xp,Yp)
	[cx cy] = obj.element_midpoint();
	in = Geometry.inpolygon(Xp,Yp,cx,cy);
	obj.elem = obj.elem(in,:);
	obj.remove_lonely_points();	
end % crop()

