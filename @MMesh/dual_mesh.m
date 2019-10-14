% Di 16. Feb 14:54:01 CET 2016
% Karl Kastner, Berlin
%
% dual mesh formed by the centre of cicumference
% the dual mesh consists not only of triangles
% TODO rename in generate dual mesh
function [dmesh obj] = dual_mesh(obj,bndflag)
	if (size(obj.elem,2) > 3)
		dMesh = [];
		warning('Only implemented for triangles');			
		return;
	end
	if (nargin < 2)
		bndflag = true;
	end
%	X = obj.X;
%	Y = obj.Y;
%	elem3 = obj.elem3;
%	X = X(elem3);
%	Y = Y(elem3);

	% create ghost elements at the boundary
	project = true;
	if (bndflag)
		obj.generate_ghost_elements(project);
%		obj.generate_ghost_elements(false);
		obj.edges_from_elements();
	end

	X = obj.elemX();
	Y = obj.elemY();
	[Xc Yc R] = Geometry.tri_excircle(X,Y);

	if (project)
		Xc(obj.eidghost) = obj.X(obj.pidghost);
		Yc(obj.eidghost) = obj.Y(obj.pidghost);
	end

	%t2t = obj.elem2elem();

	% circular
	%tn = [tn, tn(:,1)];

	% allocate memory
	T  = zeros(obj.nelem,8);
	nt = 0;

	% for each point that is not on the boundary
	pdx = (1:obj.np)';
	% exclude ghost points
	pdx(obj.pidghost) = [];
%	obj.edge(obj.bnd)) = [];


	% TODO first extract opposit edges, then chain
	% method = -1; % ok, but most not found
	% method = 0; % more found, but many missing
	method = 0;
	switch (method)
	case {-1}
		[~, ~, p2e] = obj.point_to_elem();
		for idx=rvec(pdx)
			% adjacent triangles
			% TODO store facing side on p2e
		        tid = find(p2e(idx,:));
			ne  = length(tid);
			if (ne < 3)
				% TODO bug ?
				break;
			end
			% adjoin triangle coordinates
			elem = obj.elem(tid,:);
			% remove vertex to get facing edge
			for idx=1:2
				fdx = elem(:,idx) == 0;
				elem(fdx,idx) = elem(fdx,idx+1);
			end
			edge   = elem(:,1:2);
			[pchain tchain gid] = edge_chain(edge);
			if (length(gid) > 1)
				continue;
			end
        	        nt = nt+1;
    	                T(nt,1:ne) = tid(tchain); %pchain(1:end-1);
		end % for idx
	case {0}
	% TODO, this still does not work for points on the boundary, because the ring is not closed
	% point to elem relation matrix (sparse)
	[~, ~, p2e] = obj.point_to_elem();
	t2t = obj.elem2elem_matrix();

	for idx=rvec(pdx)
	    % triangles adjacent the current vertex
            e   = find(p2e(idx,:));
            ne = length(e);
            if (length(e) > 0)
		% chain triangles by adjacency
                for jdx=1:ne-1
		    ism=false;
		    % for each remaining triangle
                    for kdx=jdx+1:ne
			% test if k-th triangle is adjacent to jth-triangle
                        if (t2t(e(jdx),e(kdx))>0)
			%ismember(e(jdx),tn(e(kdx),:)))
			    % swap
                            help     = e(jdx+1);
                            e(jdx+1) = e(kdx);
                            e(kdx)   = help;
			    ism=true;
                            break;
                        end % if ismember
                    end % for kdx
		    if (false == ism)
			break;
		    	% error('inconsistency');
		    end
                end % for jdx
		if (false == ism)
			continue;
		end
                nt = nt+1;
                T(nt,1:ne) = e;
            end % if length(e) > 0
	end
	case {1} % of is 0
		% TODO this is wrong, an element chain is needed, not a vertex chain
		p2p = obj.vertex_connectivity();
		% in 2d, interior adjacent points share two neighbours
		for idx=1:rvec(pdx)
			ei = find(p2p(idx,:));
			ne = length(ei);
			% choose any neighbour as start vertex
			e = ei(end);
			% chain other neighbours
			for jdx=2:ne
				% neighbours of the neighbour
				ej   = find(p2p(e(jdx),:));
				% next and last point are common
				next = union(ei(1:end-jdx),ej);
				if (length(next) ~= 2)
					error('Inconsistent mesh');
				end
				if (next(1) ~= e(jdx))
					e(jdx) = next(1);
				else
					e(jdx) = next(2);
				end
			end % for jdx
			% TODO, test if chain is closed
			T(nt,1:ne) = e; 
		end % for idx
	end 
	

%	for idx=1:obj.nelem
%		for jdx=1:3
%			if (idx < tn(idx,jdx) && idx < tn(idx,jdx+1))
%				nt = nt+1;
%				T(nt,:) = [idx, tn(idx,jdx), tn(idx,jdx+1)];
%			end
%		end
%	end

	% truncate
	T = T(1:nt,:);

	dmesh      = MMesh();
	dmesh.elem = T;
	dmesh.point = [Xc,Yc];
	dmesh.edges_from_elements();
end

