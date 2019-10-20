% Sun  5 Feb 12:37:16 CET 2017
% Karl Kastner, Berlin
%% chain 1D elements (segments)
% TODO, this does not yet work for circles (all connectivities are 2)
function [chain_C, obj] = chain_1d(obj)
	% chain 1d points

	% get 1d element (elements connecting to 2 points)
	elem2 = obj.elemN(2);
	% counter
	N  = zeros(obj.np,1);
	% neighbours
	NN = zeros(obj.np,2);
	% create connection "matrix"
	for idx=1:size(elem2,1)
		% left
		N(elem2(idx,1)) = N(elem2(idx,1))+1;
	        NN(elem2(idx,1),N(elem2(idx,1))) = elem2(idx,2);	
		% right
		N(elem2(idx,2)) = N(elem2(idx,2))+1;
	        NN(elem2(idx,2),N(elem2(idx,2))) = elem2(idx,1);
	end % for idx

%	scatter3(obj.X,obj.Y,N,[],N); view(0,90)

	chain_C = {};

	% get end points (has to be fetched outside iteration, as connectivity
	% is decreased within
	nc = ((N~=2) & (N~=0));

	% get next start point (n == 1 or 3)
	while (true)
		% find next end point that has at least 1 connection left
		fdx = find(nc & N>0,1);
		%find(N~=2 & N~=0,1);
		if (isempty(fdx))
			break;
		end
		% chain along NN
		c = fdx;
		while (true)
			next      = NN(c(end),N(c(end)));
			% remove from c(end( the connection to next
			N(c(end)) = N(c(end))-1;
			% remove from next the connection to c(end)
			for idx=1:N(next)-1
				if (NN(next,idx) == c(end))
					NN(next,idx) = NN(next,N(next));
					break;
				end	
			end
			N(next) = N(next)-1;
			c(end+1) = next;
			% stop if the next point is an end point
			if (nc(next))
			%N(next)+1 ~= 2)
				% terminate chain
				chain_C{end+1} = c;
				break;
			end % if not an end point
		end % while true
	end % while true
end % chain_1d

