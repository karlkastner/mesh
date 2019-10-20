% Fri 18 Nov 07:40:46 CET 2016
%
%% merge duplicate points
function obj = merge_dubplicate_points(obj,tol)
	if (nargin()<2)
		tol = 1e-7;
	end
	while (true)
	% replace duplicates with one index only
	[id dis] = knnsearch(obj.point(:,1:2),obj.point(:,1:2),'K',2);
	%id  = id(:,2);
	dis  = dis(:,2);
	fdx  = find(dis < tol);
	if (isempty(fdx))
		break;
	end
	id   = id(fdx,:);
	elem = obj.elem;
	rdx = [];
	for idx=1:size(id,1)
		% replace the higher index with the lower one
		if (id(idx,2) > id(idx,1))
			% replace indices of second vertex
			fdx = (elem == id(idx,2));
			elem(fdx) = id(idx,1);
			% mark second index for removal
			rdx(end+1) = id(idx,2);
		end % if 		
	end % for
	% TODO average pval values
	obj.elem = elem;
	rdx = unique(rdx);
	fprintf('Merging %d points\n',length(rdx));
	obj.remove_points(rdx);
	end % while true
end

