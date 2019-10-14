% Fr 29. Jan 15:07:52 CET 2016
% Karl Kastner, Berlin
function obj = interface(obj)
	% for each triangle
	% if neighbour belongs to a different segment, points are on the interface

	% common edges
	for idx=1:obj.length
	    for jdx=idx+1:obj.length
			% common edges in global point indices
			[ia ib] = ismember(obj.mesh_A(idx).elem_global, ...
                                           obj.mesh_A(jdx).elem_global);
			fdx = find(ia);
			%ib = obj.mesh_A(idx).elem(fdx);
			obj.mesh_A(idx).pinterface{jdx} = [fdx, ib(fdx)];
			%obj.mesh_A(idx).ib{jdx} = ib(fdx);
			%obj.mesh_A(idx).interface{jdx} = 
			%intersect( 	        obj.mesh_A(idx).edge_global ...
			%		      , obj.mesh_A(jdx).edge_global ...
			%		      , 'rows');
			%obj.mesh_A(jdx).interface{idx} = obj.mesh_A(idx).interface{jdx};
			% neighbourhood relation
			%if (~isemtpy(obj.mesh_A(idx).interface{jdx}))
			if (~isempty(fdx))
				obj.mesh_A(idx).sneighbour = [obj.mesh_A(idx).sneighbour, jdx];
				obj.mesh_A(jdx).sneighbour = [obj.mesh_A(jdx).sneighbour, idx];
			end
	    end % for jdx
	end % for idx
	for idx=1:obj.length
	 for jdx=1:idx-1
			[ia ib] = ismember(obj.mesh_A(idx).elem_global, ...
                                           obj.mesh_A(jdx).elem_global);
			fdx = find(ia);
			%ib = obj.mesh_A(idx).elem(fdx);
			%[ib ib_]
			%pause
			obj.mesh_A(idx).pinterface{jdx} = [fdx, ib(fdx)];
			%obj.mesh_A(idx).ib{jdx} = ib(fdx);
	 end
	end
end % calc_interface

