% Fr 29. Jan 13:45:30 CET 2016
% Karl Kastner, Berlin
%
% distance along edges from a point set to all other points
%
% open      : id of start point(s)
% countflag : if set use number of hops as distance not the euclidean distance
% 
function [d obj] = distance(obj,open,countflag)
	D = obj.vertex_distance();
	d = graphshortestpath(D,open);

if (0)
	d         = Inf(obj.np,1);
	d(open)   = 0;
	n1        = 1;
	ne        = length(open);
%	neighbour = obj.pneighbour();

	A = obj.vertex_connectivity();
	D = obj.vertex_distance();

	% TODO open should be a ring-buffer
	open = [open; zeros(obj.np,1)];
	while (true)
		% current point index
		pcurr     = open(n1);
		% indices of neighbours
		pneigh = find(A(:,pcurr));
		%pneigh = neighbour{pcurr};
		for idx=1:length(pneigh)
			% delta = 1; % count
			delta = D(pcurr,pneigh(idx));
			% only connect to neighbour if there is not yet a shorter connection
			if (d(pcurr)+delta < d(pneigh(idx)))
				d(pneigh(idx)) = d(pcurr)+delta;
				ne = ne+1;
				% push neighbour to open list
				open(ne) = pneigh(idx);
			end
		end % for idx
		% step
		n1 = n1+1;
		if (n1 >= ne)
			break;
		end		
%ne >= n1)
	end % while

end
end % distance

