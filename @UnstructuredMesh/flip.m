% So 29. Nov 16:31:41 CET 2015
% Karl Kastner, Berlin
%
%% flip edges between two triangles
%%	flip
%%	for each side
%%		if (connection between opposit points shorter than between edges, swap edge)
%%		this-> flip
%%		that-> flip
%%	end
function obj = flip(obj,tdx1,tdx2)
		T1 = obj.elem(tdx1,:);
		T2 = obj.elem(tdx2,:);

		% points shared by the triangles before flipping
		flag1 = false(1,3);
		flag2 = false(1,3);
%		np = 0;
%		q  = [0 0];
		% points not shared by the trianges before flipping
%		nq = 0; 
%		q  = [0 0];

		% determine which of the points are duplicates
		for idx=1:3
		 for jdx=1:3
			flagij = (T1(idx) == T2(jdx));
			flag1(idx) = flag1(idx) | flagij;
			flag2(jdx) = flag2(jdx) | flagij;
%				np = np+1;
%				p(np) = T1(idx);
%				d(nd,1) = idx;
%				d(nd,2) = jdx;
%				break;
%			end % if
		 end % for jdx
		end % for idx
		shared = T1(flag1);
		facing = [T1(~flag1) T2(~flag2)];

		% swap edges
		obj.elem(tdx1,:) = [shared(1), facing];
		obj.elem(tdx2,:) = [shared(2), facing];

		% TODO update edge and edge2tri
end % function flip

