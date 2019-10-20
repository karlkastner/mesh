% Thu 16 Jun 16:59:02 CEST 2016
%% delft3D requires islands to have at least 7 edges
%% this functions splits edges surrounding small islands
function obj = remove_small_islands(obj,nmin)
	if (nargin() < 2)
		nmin = obj.MIN_NUM_BND_EDGE;
	end % if
	%msk  = zeros(obj.nelem,1);
	%elem = obj.elemN(3);
	splitid = [];
	% boundary chain
	[bnde_C bnd_C] = obj.boundary_chain2();
	% for each boundary (land mass)
	for idx=1:length(bnde_C)
		bnd  = bnd_C{idx};
		bnde = cvec(bnde_C{idx});
		n    = length(bnd);
		% is the island has less than the minimum number of edges
		if (n < nmin)
			% boundary edges
			%bnd = obj.edge(bnd_C{idx},:);
			%bnd2 = [bnd, [bnd(2:end); bnd(1)]];
			% edge length
			dX = obj.X(bnde(2:end))-obj.X(bnde(1:end-1));
			dY = obj.Y(bnde(2:end))-obj.Y(bnde(1:end-1));
			l = hypot(dX,dY);
			% longest edges
			[l sdx] = sort(l,'descend');

			if (2*n>=nmin)

			% select n-nmin longest edges for splitting
			splitid = [splitid;cvec(bnd(sdx(1:nmin-n)))];

			if (0)
			%bnd = bnd_C{idx}(sdx(1:nmin-length(bnde));
			bnd2 = bnd2(sdx(1:min(size(bnd2,1),nmin-length(bnd))),:);
			% find the elements that belong to those edges
			% TODO, this is inefficient
			for jdx=1:size(bnd2,1)
				msk_ =   (elem == bnd2(jdx,1)) ...
				       + (elem == bnd2(jdx,2));
				msk_ = sum(msk_,2);
				fdx  = find(msk_ == 2);
				if (length(fdx) ~= 1)
					error('here');
				end % if
				msk(fdx) = true;
			end % for jdx
			else
				fprintf('Insufficient number of edges to split\n');
			end % if 0
			end % if 2*n >= nmin
		end % if length(bnd_C{idx})
	end % for idx
	if (1)
		obj.split_perpendicular(splitid);
		obj.edges_from_elements();
	else
		fdx = obj.edge2elem(splitid,1);
		% refine the selected elements
		%fdx = find(msk);
		fprintf(1,'Refining %d elements to increase number of edges of short boundaries to at least %d\n',length(fdx),nmin);
		if (~isempty(fdx))
			mesh2     = obj.refine(fdx);
			obj.elem  = mesh2.elem;
			obj.point = mesh2.point;
			obj.edges_from_elements();
			% recursion
			obj.remove_small_islands(nmin);
		end
	end
end % remove_small_islands

