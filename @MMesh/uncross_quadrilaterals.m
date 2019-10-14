% Wed 30 Aug 14:44:29 CEST 2017
% make sure, that 4 point elements span an area, and do not form a cross
% a call to this function should be succeeded by make_ccw
% this operator is idempotent
function obj = uncross_quadrilaterals(obj,fdx)
	if (nargin()<2)
		[elem fdx] = obj.elemN(4);
	end
	c =2;
	switch (c)
	case {0}
	% test, if the uncrossed diagonal is shorter
	X = obj.elemX(fdx);
	Y = obj.elemY(fdx);

	sdx= (   (  hypot(X(:,3) - X(:,1),Y(:,3)-Y(:,1)) ...
	        + hypot(X(:,4) - X(:,2),Y(:,2)-Y(:,2)) ) ...
	     > (  hypot(X(:,2) - X(:,1),Y(:,2)-Y(:,1)) ...
	        + hypot(X(:,4) - X(:,2),Y(:,3)-Y(:,3)) ) );
	% swap
	% uncross
	e2 = elem(sdx,2);
	elem(sdx,2) = elem(sdx,3);
	elem(sdx,3) = e2;

	case {1}
	X = obj.X;
	Y = obj.Y;

	% successively connect the shortest point
	for idx=2:4
		l = hypot(X(elem(:,idx))-X(elem(:,idx-1)), ...
		          Y(elem(:,idx))-Y(elem(:,idx-1)));
		for jdx=idx+1:4
			l_ = hypot(X(elem(:,idx-1))-X(elem(:,jdx)), ...
		        	   Y(elem(:,idx-1))-Y(elem(:,jdx)));
			sdx = (l_ < l);
			e_ = elem(sdx,idx);
			elem(sdx,idx) = elem(sdx,jdx);
			elem(sdx,jdx) = e_;
			l(sdx) = l_(sdx);
			sum(sdx)
		end
	end
	case {2}
		% least circumference, only swapped diagonals have to be compared
		X = obj.X;
		Y = obj.Y;
		% abcd vs abdc
		sdx = ( hypot(X(elem(:,4))-X(elem(:,1)),Y(elem(:,4))-Y(elem(:,1))) ... % ad
		   + hypot(X(elem(:,3))-X(elem(:,2)),Y(elem(:,3))-Y(elem(:,2))) ...    % bc
		   > hypot(X(elem(:,3))-X(elem(:,1)),Y(elem(:,3))-Y(elem(:,1))) ...    % ac
		   + hypot(X(elem(:,4))-X(elem(:,2)),Y(elem(:,4))-Y(elem(:,2))) );     % bd
		% swap cd
		[sum(sdx) length(sdx)]
		elem_ = elem(sdx,3);
		elem(sdx,3) = elem(sdx,4);
		elem(sdx,4) = elem_;
		% abcd vs acbd
		sdx = ( hypot(X(elem(:,2))-X(elem(:,1)),Y(elem(:,2))-Y(elem(:,1))) ... % ab
		   + hypot(X(elem(:,4))-X(elem(:,3)),Y(elem(:,4))-Y(elem(:,3))) ...    % cd
		   > hypot(X(elem(:,3))-X(elem(:,1)),Y(elem(:,3))-Y(elem(:,1))) ...    % ac
		   + hypot(X(elem(:,4))-X(elem(:,2)),Y(elem(:,4))-Y(elem(:,2))) );     % bd
		% swap bc
		elem_       = elem(sdx,2);
		elem(sdx,2) = elem(sdx,3);
		elem(sdx,3) = elem_;
		sum(sdx)
	end
	obj.elem(fdx,1:4) = elem;
end % uncross_quadrilaterals

