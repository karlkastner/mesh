
% Karl Kastner, Berlin
% limit by distance 
% val : value at vertices
% p   : maximum relative growth
function [val obj] = limit_by_distance(obj,val,p)
	% vetex indices for each edge
	edx    = obj.edge();
	% edge length
	l_edge = obj.edge_length();
	% this terminates with at most np steps and 
	% for reasonable 2d meshes on average sqrt(np) steps
	iter = 0;
	while (true)
		val_old  = val;
		% left
		val = min(val,accumarray(edx(:,1),val(edx(:,2)) + l_edge*(p-1),[obj.np,1],@min,inf));
		% right
		val = min(val,accumarray(edx(:,2),val(edx(:,1)) + l_edge*(p-1),[obj.np,1],@min,inf));
	
		% for each point, get distance to neighbour
		%v2v = vertex_to_vertex()
		%fdx = find(v2v(:));
		%l_v2v  = l(v2v);
		%% max edge length
		%l0  = v2v_I*spdiag(l_vertex);
		%l_A = l0 + (1-p)*
		%% minimum distance
		%% TODO, this will always be zero
		%l_vertex = 

		if (0==max(abs(val-val_old)))
			break;
		end
		iter = iter+1;
	end % while true
end % function limit_by_distance

