% Di 9. Feb 14:49:11 CET 2016
% Karl Kastner, Berlin
%
% mesh refinement by longest edge bisection
% TODO, propagate longest edge and put closure last
%
function obj = refine_edge_halving(obj,sdx)
	% for each selected edge
	for idx=rvec(sdx)
		% insert midpoint
		pdx      = obj.edge(idx,:)
		point_c  = mean(obj.point(pdx,:));
		np = obj.np;
		pc = np+1;
		obj.point(pc,:) = point_c;
		plot(point_c(1),point_c(2),'ro');
%if (0)
		% for each of the two adjacent elements
		tdx = obj.edge2elem(idx,:);
		for jdx=tdx
		if (jdx > 0)
			% get points
			elemj = obj.elem(jdx,:);
			% get the third point
			p3 = setdiff(elemj,pdx);
			% update
			obj.elem(jdx,:) = [pdx(1),p3,pc];
			% insert new elem
			nt = obj.nelem;
			nt = nt+1;
			obj.elem(nt,:) = [pdx(2),p3,pc];
			% TODO update edge to triangle relationship
		end % if jdx > 0
		end
%		obj.edges_from_elements();
%end
	end
end

