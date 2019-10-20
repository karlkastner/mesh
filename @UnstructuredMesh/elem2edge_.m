% Di 9. Feb 13:36:21 CET 2016
%
%% pointer of element to edge
%
function elem2edge = elem2edge(obj)
	edge2elem = obj.edge2elem;
	elem2edge = zeros(obj.nelem,3);
	n = zeros(obj.nelem,1);
	for idx=1:2
		fdx = find(edge2elem(:,idx) > 0);
		%elem2edge{fdx} = elem2edge
		% this cannot be simultaneously evaluated, as successive elements may connect to the same edge
		for jdx=rvec(fdx)
			elem   = edge2elem(jdx,idx);
			n(elem) = n(elem)+1;
			elem2edge(elem,n(elem)) = jdx;
		end
	end
	% sort the indices, such that opposit side is facing
	elem2edge_ = elem2edge;
	for idx=1:obj.nelem
		for jdx=1:3
			edge = obj.edge(elem2edge_(idx,jdx),:);
			for kdx=1:3
				if (edge(1) ~= obj.elem(idx,kdx) && edge(2) ~= obj.elem(idx,kdx))
					elem2edge(idx,kdx) = elem2edge_(idx,jdx);
				end
			end
		end
	end
	% test
if (0)
	a = [2 3 1];
	b = [3 1 2];
	for idx=1:obj.nelem
		for jdx=1:3
			edge = obj.edge(elem2edge(idx,jdx),:);
			
			if (norm(sort(edge)-sort([obj.elem(idx,a(jdx)),obj.elem(idx,b(jdx))])))
				error('here')
			end
		end
	end
end
end

