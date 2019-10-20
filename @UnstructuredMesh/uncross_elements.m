% Wed 30 Aug 14:44:29 CEST 2017
%% make sure, that 4 point elements span an area, and do not form a cross
%% a call to this function should be succeeded by make_ccw
%% this operator is idempotent
function obj = uncross_quadrilaterals(obj)
%	if (nargin()<2)
%		fdx = (sum(obj.elem>0,2)>3);
%	end

	X = obj.X;
	Y = obj.Y;

	for ndx=4:size(obj.elem,2)
		[elem id] = obj.elemN(ndx);
		if (~isempty(elem))
		change = true;
		while (change)
			change = false;
			for idx=1:ndx-1
			  % the immediate neighbour cannot be over cross with this edge
			  for jdx=idx+2:ndx
			    if (jdx ~= ndx || 1~=idx)
				% least circumference, only swapped diagonals have to be compared
			        sdx = (   hypot(X(elem(:,idx+1))-X(elem(:,idx)), ...
                                                Y(elem(:,idx+1))-Y(elem(:,idx))) ...  % ab
			                + hypot(X(elem(:,jdx))-X(elem(:,mod(jdx,ndx)+1)), ...
					        Y(elem(:,jdx))-Y(elem(:,mod(jdx,ndx)+1))) ...  % cd
        	        	      >   hypot(X(elem(:,jdx))-X(elem(:,idx)), ...
					        Y(elem(:,jdx))-Y(elem(:,idx))) ...      % ac
                	   	        + hypot(X(elem(:,idx+1))-X(elem(:,mod(jdx,ndx)+1)), ...
                                                Y(elem(:,idx+1))-Y(elem(:,mod(jdx,ndx)+1))) ... % bd
				      );
				% bring b ... c in reverse order
				elem(sdx,idx+1:jdx) = fliplr(elem(sdx,idx+1:jdx));
				change = change || any(sdx);
			    end % if jdx ~= ndx ...
			  end % for jdx
			end % for idx
		end % while
		obj.elem(id,1:ndx) = elem;
		end % if ~isempty(elem)
	end % for ndx

end % uncross_elements

