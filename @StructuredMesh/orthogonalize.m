% Tue 27 Nov 14:55:04 CET 2018
function orthogonalize(obj,opt)
	if (nargin()<2)
		opt = struct();
	end
	if (~isfield(opt,'relax'))
		opt.relax = 0.001;
	end

	if (~isfield(opt,'maxiter'))
		opt.maxiter = 1000;
	end

% this ignores influence of projection on the centroid
	n = obj.n;
	nn = prod(obj.n);
	id = reshape(obj.id,obj.n);
%id
%pause
	for idx=1:opt.maxiter

	% left-right, top-bottom index
	eid = obj.edge;

	X = obj.X;
	Y = obj.Y;

	% edge point coordinates
	xy1 = [X(eid(:,1),Y(eid(:,1))];
	xy2 = [X(eid(:,2),Y(eid(:,2))];
%	xy1 = [flat(X(:,1:end-1)),flat(Y(:,1:end-1));
%	       NaN*flat(X(1:end-1,:)'),flat(Y(1:end-1,:)')];
%	xy2 = [flat(X(:,2:end)),flat(Y(:,2:end));
%	       NaN*flat(X(2:end,:)'),flat(Y(2:end,:)')];

%nannorm(X(eid1)-xy1(:,1))
%nannorm(Y(eid1)-xy1(:,2))
%nannorm(X(eid2)-xy2(:,1))
%nannorm(Y(eid2)-xy2(:,2))
%pause

	% centroid of elements
	% TODO this are actually mid-points not centroids
	[Xc, Yc] = obj.elem_centre();
%hold on
%plot(Xc,Yc,'.');

	% centroids of elements neighbouring the edges edges
	xyc1 = [ flat([NaN(n(1)-1,1), Xc]'), flat([NaN(n(1)-1,1), Yc]');
	         flat([NaN(1,n(2)-1); Xc]), flat([NaN(1,n(2)-1); Yc])
		];
	xyc2 = [ flat([Xc, NaN(n(1)-1,1)]'), flat([Yc, NaN(n(1)-1,1)]'); 
	         flat([Xc; NaN(1,n(2)-1)]), flat([Yc; NaN(1,n(2)-1)])
		];
%xyc1	
%	plot([xyc1(:,1),xyc2(:,1)],[xyc1(:,2) xyc2(:,2)])
%pause

	% translate left centroid to [0,0]
if (1)
	xyc2 = xyc2 - xyc1;
	xy1 = xy1 - xyc1;
	xy2 = xy2 - xyc1;
	h    = hypot(xyc2(:,1),xyc2(:,2));
	s    = 1./h;
	R    = bsxfun(@times,xyc2,s);
	xy1 = bsxfun(@times,xy1,s);
	xy2 = bsxfun(@times,xy2,s);
	% rotate so that x of xyc2 is at [1,0]; 
	xyc2 = [R(:,1).*xyc2(:,1) + R(:,2).*xyc2(:,2), -R(:,2).*xyc2(:,1)+ R(:,1).*xyc2(:,2)];
	xy1 = [R(:,1).*xy1(:,1) + R(:,2).*xy1(:,2), -R(:,2).*xy1(:,1)+ R(:,1).*xy1(:,2)];
	xy2 = [R(:,1).*xy2(:,1) + R(:,2).*xy2(:,2), -R(:,2).*xy2(:,1)+ R(:,1).*xy2(:,2)];
	%% set x of point coordinates to 1/2
	%xy1(:,1) = 0.5;
	%xy2(:,1) = 0.5;
	% get orthogonality
	dxy = xy1-xy2;
	o = dxy(1)./hypot(dxy(:,1),dxy(:,2));

	% average x coordinates
	xy1(:,1) = 0.5*(xy1(:,1)+xy2(:,1));
	xy2(:,1) = xy1(:,1);
	% rotate back
	xy1 = [R(:,1).*xy1(:,1) + -R(:,2).*xy1(:,2), R(:,2).*xy1(:,1)+ R(:,1).*xy1(:,2)];
	xy2 = [R(:,1).*xy2(:,1) + -R(:,2).*xy2(:,2), R(:,2).*xy2(:,1)+ R(:,1).*xy2(:,2)];
	% scale back
	xy1 = bsxfun(@times,xy1,h);
	xy2 = bsxfun(@times,xy2,h);
	% translate back
	xy1 = xy1 + xyc1;
	xy2 = xy2 + xyc1;
end

%X
	x = accumarray(eid(:),[xy1(:,1);xy2(:,1)], [nn,1], @nanmean,0);
	y = accumarray(eid(:),[xy1(:,2);xy2(:,2)], [nn,1], @nanmean,0);
	x = reshape(x,obj.n);
%x
%pause
%	x(eid1) = xy1(:,1);
%	nannorm(x-X)
%	x(eid1) = xy1(:,1);
%	nannorm(x-X)
%	x-X
%pause
	y = reshape(y,obj.n);

	p = opt.relax;
	X = (1-p)*obj.X + p*x;
	Y = (1-p)*obj.Y + p*y;
	fdx = isnan(X);
	obj.X(~fdx) = X(~fdx);
	obj.Y(~fdx) = Y(~fdx);

%	clf
%	opt_.edgecolor = 'r';
%	obj.plot([],opt_)
%	pause
	end % for idx
end

