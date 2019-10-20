% Di 27. Okt 03:10:12 CET 2015
%% set up element2element neighbourhood relation
function [obj] = compute_elem2elem(obj)

	% elem2elem
	% TODO this works only for triangles
	P       = obj.point(:,1:2);
	[T fdx] = obj.elemN(3);
	B = [];
	elem2elem = zeros(obj.nelem,3);

	% 2d common edge
	if (~isempty(fdx))
		elem2elem(fdx,:) = element_neighbour_2d(P, T, B, false);
	end

	% 1d neighbours if there is a common point,
	% at junctions, there can be more than 2 neighbours
	% TODO this may fail for loop elements, that connect with both ends to the same point
	[elem2 id] = obj.elemN(2);
	if (~isempty(elem2))
		id_local = (1:length(id))';
		A  = [elem2(:,1) id_local; elem2(:,2) id_local];
		A  = sortrows(A);
		nn = zeros(size(elem2,1),1);
		% this will be resized, if there are junctions where
		% the adjoining elements have more than 2 neighbours
		N  = zeros(size(elem2,1),2);
		idx=1;
		jdx=2;
		while (idx<size(A,1))
			while (jdx<=size(A,1) && A(jdx,1) == A(idx,1))
				% connect all of the previous elements connecting to this point to jdx
				for kdx=idx:jdx-1
					% increment neighbour counter
					nn(A(kdx,2))             = nn(A(kdx,2))+1;
					% neighbourhood relation
					N(A(kdx,2),nn(A(kdx,2))) = id(A(kdx,2));
					nn(A(jdx,2))             = nn(A(jdx,2))+1;
					N(A(jdx,2),nn(A(jdx,2))) = id(A(kdx,2));
				end
				jdx=jdx+1;
			end % while jdx
			idx=jdx;
			jdx=jdx+1;
		end % while idx
		% local 2 global
		elem2elem(id,1:size(N,2)) = N;
	end % if (~isempty(elem2)

	obj.elem2elem = elem2elem;
end

