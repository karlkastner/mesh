% 2016-10-26 16:10:51.383803629 +0200

% TODO number of encroached edges
% TODO deviation from optimum angle
% TODO distance incentre excentre
function [stat obj] = statistics(obj)
	stat = struct();

	stat.nelem        = obj.nelem;
	stat.np           = obj.np;

	% edge length
	stat.ledge.val    = obj.edge_length();
	stat.ledge.median = median(stat.ledge.val);
	stat.ledge.min    = min(stat.ledge.val);
	stat.ledge.max    = max(stat.ledge.val);
	% topology 
	N = full(sum(obj.vertex_to_vertex()));
	% exclude points on boundary
	bnd = obj.edge(obj.bnd,:);
	N(bnd(:)) = [];
	n=(0:max(N));
	n(2,:)=histc(N,n);
	stat.connectivity=n;

	stat.area.val         = obj.element_area;
	stat.area.median = median(stat.area.val);
	stat.area.min    = min(stat.area.val);
	stat.area.max    = max(stat.area.val);

	% triangulation specific statistics
	if (3 == size(obj.elem,2))
	isacute          = obj.isacute();
	isacute(isnan(isacute)) = 1;
	% TODO this is not quite right for right triangles
	isobtuse = ~isacute;
	angle             = acos(obj.angle());
	stat.angle.val    = angle;
	stat.nobtuse      = sum(isobtuse);
	stat.angle.max    = max(angle,[],2);
	stat.angle.min    = min(angle,[],2);
	stat.angle.maxmax = max(stat.angle.max);
	stat.angle.minmin = min(stat.angle.min);
	end
	

	%quality.nelem(iter)  = obj.nelem;
	%quality.np(iter)     = obj.np;
	%quality.noptuse(iter) = nobtuse
	%quality.qangle(iter,:)      = quantile(flat(angle),[0 normcdf(-3:3) 1]);
	%quality.q_max_angle(iter,:) = quantile(max_angle,[0 normcdf(-3:3) 1]);
	%quality.q_min_angle(iter,:) = quantile(min_angle,[0 normcdf(-3:3) 1]);
end

