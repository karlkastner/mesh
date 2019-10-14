% Mon 26 Sep 13:38:09 CEST 2016
% Karl Kastner, Berlin
%
% P : one column in f for each vertex
%
%
function [f g H g_] = objective_P_midpoint(E,P,bnd)
	nT = size(E,1);
	nP = size(P,1);
	X = P(:,1);
	Y = P(:,2);
	XT = X(E);
	YT = Y(E);
	if (1 == size(E,1))
		XT = rvec(XT);
		YT = rvec(YT);
	end

	% sq distance to opposit midpoint
	d2 = Geometry.tri_distance_opposit_midpoint(XT,YT);
	% sq radius around opposit midpoint
	r2 = 0.25*Geometry.tri_side_length(XT,YT);
	% objective function value per triangle
	fT = 3*r2 - d2;
	
	% maximum per point
	mid   = accumarray(E(:),(1:3*nT)',[],@(id) maxid(fT(:),id));
	midT  = mod(mid-1,nT)+1;
	midC  = idivide(int32(mid-1),int32(nT))+1;
	f     = fT(mid);

	% fore each point fetch the triangle with maximum angle
	E_ = E(midT,:);

	% reorder the points, such that the index of the each point comes first
	for idx=1:nP
		E_(idx,:) = circshift(E_(idx,:),[0, -(midC(idx)-1)]);
	end
	% test
	if (norm(E_(:,1)-(1:nP)','inf')>0)
		error('here');
	end
	if (nargout() > 1)
	 % compute the gradient

	XT = X(E_);
	YT = Y(E_);

	ax = XT(:,1);
	bx = XT(:,2);
	cx = XT(:,3);
	ay = YT(:,1);
	by = YT(:,2);
	cy = YT(:,3);

%	 g = zeros(nP,2);
	% note: accummarray is necessary, as otherwise values in one column of referenceing to same row are not addded!

	gx = accumarray(E_(:),	 [bx - 2*ax + cx;
				  ax + bx - 2*cx;
				  ax - 2*bx + cx]);

	gy = accumarray(E_(:), [by - 2*ay + cy;
				 ay + by - 2*cy;
				 ay - 2*by + cy]);
	g = [gx;gy];
	end
	H  = [];
	g_ = [];
end

