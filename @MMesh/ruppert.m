% 2016-07-24 12:35:49.383237065 +0200
% Karl Kastner, Berlin

% c.f. ruppert 1993, 1994
function obj = refine_ruppert(obj,alphamin)
	cosamin = cos(alphamin);
	% while there are triangles not satisfying the minimum angle constraint
	while (true)
		obj.remove_encroached_edges();

		% find first triangle violating the min angle constraint
		% TODO sort
		cosa = Geometry.tri_angle(XT,YT);
		tdx  = find(any(cosa < cosamin,2),1);
		if (~isempty(tdx))
			[x0 y0] = Geometry.circumcentre(XT,YT);
			tdx2    = Geometry.contains(X,Y,x0,y0);
				% TODO, what if circumcentre is outside?

			restore_delaunay = true;
			obj.trisplit(tdx2,x0,y0,restore_delaunay);
			% TODO restore delaunay by fliping the children
			continue;
		end
		break;
	end % while 1
end % ruppert

