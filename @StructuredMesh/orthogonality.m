% Tue 27 Nov 16:47:43 CET 2018
function cosa = orthogonality(obj)
	eid = obj.edge;
	n = obj.n;

	X = obj.X;
	Y = obj.Y;

	% edge point coordinates
	xy1 = [X(eid(:,1)),Y(eid(:,1))];
	xy2 = [X(eid(:,2)),Y(eid(:,2))];

	[Xc, Yc] = obj.elem_centre();

	xyc1 = [ flat([NaN(n(1)-1,1), Xc]'), flat([NaN(n(1)-1,1), Yc]');
	         flat([NaN(1,n(2)-1); Xc]), flat([NaN(1,n(2)-1); Yc])
		];
	xyc2 = [ flat([Xc, NaN(n(1)-1,1)]'), flat([Yc, NaN(n(1)-1,1)]'); 
	         flat([Xc; NaN(1,n(2)-1)]), flat([Yc; NaN(1,n(2)-1)])
		];
	dxyc = xyc1 - xyc2;
	
	dxy  = xy1-xy2;
	cosa = ( dxy(:,1).*dxyc(:,1) + dxy(:,2).*dxyc(:,2) ) ...
		./ (hypot(dxy(:,1),dxy(:,2)).*hypot(dxyc(:,1),dxyc(:,2)));
end

