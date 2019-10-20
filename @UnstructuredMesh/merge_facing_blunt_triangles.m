% Di 16. Feb 16:39:16 CET 2016
% Karl Kastner, Berlin 
%
%% merge blunt triangles that face each other
%
function [obj] = merge_facing_blunt_triangles(obj,thresh)
	T = obj.elem();

	% get element neighbours
	N = obj.tneighbour();

	% get element angles
	cosa = obj.angle();
	
	keep  = true(obj.nelem,1);
	left  = obj.left; %l = [3 1 2];
	right = obj.right; %r = [2 3 1];
	% merge elements whose facing angles are about 90deg
	for t1=1:obj.nelem
		% if not yet merged
		if (keep(t1))
		% for each corner
		for p1=1:3
			t2 = N(t1,p1);
			% avoid boundary
			if (t2 > 0)
			% find facing corner
			% TODO this information can be stored and is not necessary to be computed each time
			for p2=1:3
				if (T(t2,p2) ~= T(t1,left(p1)) && T(t2,p2) ~= T(t1,right(p1)))
					break;
				end % if facing angle
			end % for p2
			% check that facing corners are almost right
			if (abs(cosa(t1,p1)) < thresh && abs(cosa(t2,p2)) < thresh)
				% are these points always in order?
				T(t1,1:4) = [T(t1,left(p1)), T(t1,p1) T(t1,right(p1)), T(t2,p2)];
				%T(t1,:)
				%idx=idx+1
				%figure(idx);
				%clf();
				%patch(1e-3*X(T(t1,:))',1e-3*Y(T(t1,:))',1,'facecolor','none','edgecolor','r');	
				%drawnow
				% mark second element for deletion
				keep(t2) = false;
				% merge only once
				break;
			end % if merge condition met
			end
		end % for p1
		end % if keep
	end
	% delete other elements
	n        = obj.nelem;
	obj.elem = T(keep,:);
	obj.edges_from_elements();
	printf('Merged %d triangle pairs into quadrilaterals\n',n-obj.nelem);
end % merge_facing_blunt_triangles

