% Mon 26 Sep 17:36:00 CEST 2016
% Karl Kastner, Berlin
function [f g g_] = objective_3_angle(X,Y,alpha0)
	cosa = Geometry.tri_angle(X,Y);

%	cosa = Geometry.dot(X(:,3)-X(:,1),Y(:,3)-Y(:,1), ...
%			    X(:,2)-X(:,1),Y(:,2)-Y(:,1));
	alpha = acos(cosa);
	f = (alpha - alpha0).^2;
end

