% Thu 29 Sep 15:53:17 CEST 2016
%
%% improve mesh by removing one edge from vertices with 8-edges
%% (an interior vertex in a regular triangulation has 6 neighbours,
%%  and unstructured meshes with local refinement are possible with
%%  5 and 7 neighbours, 4,3, or 8 and more connected vertices are not necessary
%
function obj = resolve_8_vertices(obj)
	while (1)
		A     = obj.vertex_connectivity();
		pdx   = find(sum(A) == 8);
		if (0 == length(pdx))
			break;
		end
		flagT = false(obj.nelem,1);
		for idx=1:length(pdx)
			% TODO use point to elem
			tdx = find(obj.elem(:,1) == pdx(idx) ...
				|  obj.elem(:,2) == pdx(idx) ...
				|  obj.elem(:,3) == pdx(idx));
		%	figure(1);
		%	clf
			%triplot(obj.elem(tdx,:),obj.X,obj.Y);
			%hold on
			nt = length(tdx); % nt == np
			% check if not yet processed
			if (any(flagT(tdx)))
				continue;
			end
			flagT(tdx) = true;
			% get neighbouring vertices
			ndx = find(A(:,pdx(idx)));
			edge = zeros(nt,2);
			for jdx=1:3
				% do not swap following two lines
				edge(:,2) =  edge(:,2) + (edge(:,1) ~= 0).*(obj.elem(tdx,jdx) ~= pdx(idx)).*obj.elem(tdx,jdx);
				edge(:,1) =  edge(:,1) + (edge(:,1) == 0).*(obj.elem(tdx,jdx) ~= pdx(idx)).*obj.elem(tdx,jdx);
			end
			ndx=edge_chain(edge);
			% first point
			p1 = pdx(idx);
			obj.point(pdx(idx),1:2) = mean([obj.point(ndx(1:4),1:2)],1);
			% second point
			 np = obj.np+1;
			 p2 = np;
			 obj.point(np,1:2) = mean([obj.point(ndx(5:8),1:2)],1);
			% triangulate, 1 and 5 are shared
			T = [ ndx(1) ndx(2) p1;
			      ndx(2) ndx(3) p1;
			      ndx(3) ndx(4) p1;
			      ndx(4) ndx(5) p1;
			      ndx(5) ndx(6) p2;
			      ndx(6) ndx(7) p2;
			      ndx(7) ndx(8) p2;
			      ndx(8) ndx(1) p2;
			      p1     p2     ndx(1);
			      p1     p2     ndx(5)];
			
			if (0)
			% distance matrix
			X = cvec(obj.X(ndx));
			Y = cvec(obj.Y(ndx));
			d2 = bsxfun(@minus,X,X').^2 + bsxfun(@minus,Y,Y').^2;
			[void id] = max(d2(:));
			[p1 p2]  = ind2sub([length(X),length(X)],id);
			% local to global
			p1 = ndx(p1);
			p2 = ndx(p2);
			% update coordinates of interior point
			obj.point(pdx(idx),1:2) = 1/3*[obj.X(p1) obj.Y(p1)] + 2/3*[obj.X(p2) obj.Y(p2)];
			% new point
			np = obj.np+1;
			obj.point(np,1:2) = 2/3*[obj.X(p1) obj.Y(p1)] + 1/3*[obj.X(p2) obj.Y(p2)];
			% retriangulate
			id = [pdx(idx); ndx; np];
			T  = delaunay(obj.X(id),obj.Y(id));
			% local to global indices
			T = id(T); 
			end
			if (size(T,1) ~= nt+2)
				error('here');
			end
			% update existing elements
			obj.elem(tdx,:) = T(1:nt,:);
			% append two new elements
			nelem = obj.nelem;
			obj.elem(nelem+1:nelem+2,:) = T(nt+1:end,:);
			flagT(nelem+1:nelem+2) = true;
			%triplot(T,obj.X,obj.Y,'color','r')
			%pause
		end % for idx
		obj.edges_from_elements();
	end % while
end % resolve_8_vertices

