% Fri  8 Nov 11:11:11 +08 2019
% cross-section through mesh
function [pxy_, sid, fdx] = section(obj,x,y)
	% coordinates of mesh edge endpoints
	e1xy = obj.point(obj.edge(:,1),1:2);
	e2xy = obj.point(obj.edge(:,2),1:2);

	% mark edges interesected by the polygon
	flag  = zeros(obj.nedge,1);
	pxy_  = zeros(obj.nedge,size(obj.point,2));
	t_    = zeros(obj.nedge,1);
	for idx=1:size(x,1) %pxy,1)-1
		[flagi, s, t, p, q, den] = Geometry.lineintersect( ...
						e1xy(:,1:2)',e2xy(:,1:2)', ...
						[x(idx,1); y(idx,1)], ...
						[x(idx,2); y(idx,2)] );
						%pxy(idx,:)',pxy(idx+1,:)');
						%pxy(idx,:)',pxy(idx+1,:)');
		t=s;
		% mark splitted edges
		flag     = flag + cvec(flagi);
		% order points along intersect (for cross-section)
		t        = t(flagi);
		[ts,sdx]  = sort(t);
		flagi    = find(flagi);
		sid{idx} = flagi(sdx);

		% coordinates of intersection
		p        = squeeze(p).';
		p        = p(flagi,:);
		pxy_(flagi,1:2) = p;
		t_(flagi)   = t;
	end
	% TODO make it work for multiple intersection
	if (max(flag)>1)
		error('multiple edge intersection not supported so far');
	end
	fdx  = find(flag);
	pxy_ = pxy_(fdx,:);

	% indices of new points
	pid       = (1:length(fdx));
	pid_(fdx) = pid;
	for idx=1:length(sid)
		sid{idx} = pid_(sid{idx});
	end

	% interpolate values to intersections
	if (size(obj.point,2)>2)
		t_ = t_(fdx);
		v  = obj.Z;
		v  = v(obj.edge(fdx,:));
		% the interpolation is more trivial, as it takes place on edges (1d)
		v  = (1-t_).*v(:,1) + (t_).*v(:,2);
		%v  = t_.*v(:,1) + (1-t_).*v(:,2);
		% pxy_(:,end)      = obj.interp_2d(pxy_(:,1:2));
		pxy_(:,end)      = v;
	end
end % section


