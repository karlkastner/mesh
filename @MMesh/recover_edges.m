% So 29. Nov 15:43:47 CET 2015
% Karl Kastner, Berlin
%
% recover (boundary) edges
%
function obj = recover_edges(obj,Er)
	q1 = obj.point(Er(:,1))';
	q2 = obj.point(Er(:,2))';
	% for each boundary edge
	for idx=1:size(Er,1)
		while (1)
			p1 = obj.point(obj.E(:,1),:)';
			p2 = obj.point(obj.E(:,2),:)';

			% determine the first edge that is crossing the boundary edge
			% TODO this is stupid slow, find by hangling along neighbouring edges
			% this has to be recommputed, as the triangulation changes after the first edge swap
			flag = Geometry.lineintersect(p1',p2',q1(:,idx),q2(:,idx));
			e2   = find(flag,1);
			% if no crossing edges (boundary edge is restored)
			if (isempty(e2))
				break;
			end
			% determine triangles that are connected to the cutting edge
			tdx = obj.e2t(e2,:);
			% flip the edge between the triangles
			obj.flip(tdx(1),tdx(2));
		end % while 1
	end % for idx
end % recover_edges

