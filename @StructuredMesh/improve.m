% Do 1. Okt 12:07:23 CEST 2015
% Karl Kastner, Berlin
function obj = improve(obj)
	maxIter = 15;
	abstol  = 1e-7;
	p = 0.5;
	
	XX = obj.X;
	YY = obj.Y;
	siz = size(XX);
	n = prod(siz);

	% until convergence
	idx = 0;
	while (true)
		X = full(XX(obj.elem));
		Y = full(YY(obj.elem));

		% for each element compute cell centre
		cX = mean(X,2);
		cY = mean(Y,2);
		% compute delta x and y for each corner point
		dx = p*bsxfun(@minus,cX,X);
		dy = p*bsxfun(@minus,cY,Y);
		% accummulate and apply dx and dy
		dx = accumarray(flat(obj.elem),flat(dx),[n 1],[],[],false);
		XX = XX + reshape(dx,siz); 
		dy = accumarray(flat(obj.elem),flat(dy),[n 1],[],[],false);
		YY = YY + reshape(dy,siz); 
		
%		% project boundary points back to the boundary
%		for idx=1:length(obj.BC)
%		% do not inhibit movement of interior boundaries
%		field_C = {'north','east','south','west'};
%		for sdx=1:length(field_C)
%		field = field_C{idx};
%		if (obj.BC(idx).(field).outer ~= true)
%			c = obj.BC(idx).(field).cdx;
%			e = obj.BC(idx).(field).edx;
%
%			id = sub2ind(siz,c,e);
%			x = XX(id);
%			y = YY(id);
%			for jdx=1:length(x)
%				% closest point on boundary
%				dx_ = BC(idx).(field).X_ - x(jdx);
%				dy_ = BC(idx).(field).Y_ - y(jdx);
%				[mv mdx] = min(dx_.^2 + dy_.^2);
%				% project onto boundary
%				% TODO, at least linear interpolation
%				x(idx) = BC(idx).(field).X_(mdx);
%				y(idx) = BC(idx).(field).Y_(mdx);
%			end
%			XX(id) = x;
%			YY(id) = y;
%		end % if not an outer boundary
%		end % for each boundary

		% test for convergence
		if (max(dx.^2+dy.^2) < abstol^2)
			break;
		end % if
		% test for end of iteration
		idx = idx+1;
		if (idx > maxIter)
			warning('No convergence');
			break;
		end % if
	end % while no convergence
	obj.X = XX;
	obj.Y = YY;
end % function mesh_improve

