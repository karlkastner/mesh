% Mon 26 Sep 17:36:00 CEST 2016
% Karl Kastner, Berlin
function [f g H] = objective_angle(X,Y,alpha0,p)
	a = Geometry.tri_area(X,Y);
	if (~issym(a(1)) && any(a<0))
		f = NaN;
		g = NaN;
		H = NaN;
		return;
	end
	cosa  = Geometry.dot(X(:,3)-X(:,1),Y(:,3)-Y(:,1), ...
			     X(:,2)-X(:,1),Y(:,2)-Y(:,1));
	% TODO get ddot
	alpha = acos(cosa);
	f     = (alpha - alpha0).^p;
end

