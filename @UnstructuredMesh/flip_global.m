% Wed 28 Sep 16:25:37 CEST 2016
% Karl Kastner, Berlin
%% recursively flip edges, i.e ABC+BCD -> ABD+ADC,
%% when new edge (diagonal) is shorter
%% TODO this is buggy, it cannot be always swapped, only if abcd is convex!
function obj = flip_global(obj)
%	obj.edges_from_elements();
	iter = 0;
	while (1)
		figure(iter+1)
		clf
		opt.edges = true;
		opt.elem_edgecolor = 'r';
		obj.plot(zeros(obj.np,1),opt) 	

%		a = abs(obj.element_area());
%		fdx=a==0;
%if(~isempty(find(fdx)))
%		obj.elem(fdx,:)
%x=obj.X(obj.elem(fdx,:))
%y=obj.Y(obj.elem(fdx,:)) %-1e7
%x(end+1) = x(1);
%y(end+1) = y(1);
%Geometry.poly_area(x,y)
%Geometry.poly_area(x,y-1e7)
%end
%		A(iter+1,1)=sum(a);
%		A(iter+1,2)=min(a);
		disp(iter);
		tdx = obj.edge2elem();
		% remove boundary edges
		tdx   = tdx(none(tdx==0,2),:);
		% first element on side of edge
		elem1 = obj.elem(tdx(:,1),:);
		% second element
		elem2 = obj.elem(tdx(:,2),:);
		% determine common and opposit vertices
		com = zeros(size(tdx,1),2);
		dis = zeros(size(tdx,1),2);
		for idx=1:3
		 d1 = true(size(tdx,1),1);
		 d2 = true(size(tdx,1),1);
		 for jdx=1:3
			c1       = (elem1(:,idx) == elem2(:,jdx));
			d1       = d1 & ~c1;
			c2       = (elem1(:,jdx) == elem2(:,idx));
			d2       = d2 & ~c2;
			% do not swap following two lines
			com(:,2) = com(:,2) + c1.*(com(:,1) ~= 0).*elem1(:,idx);
			com(:,1) = com(:,1) + c1.*(com(:,1) == 0).*elem1(:,idx);
                 end
		 dis(:,1) = dis(:,1) + d1.*elem1(:,idx);
		 dis(:,2) = dis(:,2) + d2.*elem2(:,idx);
		end

		% determine common edge length
		e2 = (obj.X(com(:,1))-obj.X(com(:,2))).^2 + (obj.Y(com(:,1))-obj.Y(com(:,2))).^2;
		% diagonal length
		d2 = (obj.X(dis(:,1))-obj.X(dis(:,2))).^2 + (obj.Y(dis(:,1))-obj.Y(dis(:,2))).^2;

		% determine elements where diagonal is shorter than common edge
		fdx = find(d2 < e2);

		% only flip convex quads
		e   = [com(fdx,1),dis(fdx,1),com(fdx,2),dis(fdx,2)];
		X = obj.X;
		Y = obj.Y;
		cdx = Geometry.quad_isconvex(X(e),Y(e));
		fdx = fdx(cdx);

		printf('Flipping %d edges\n',length(fdx));
		% flip element edge with diagonal
		if (0 == length(fdx))
			break;
		end
		ddx = find(dis(:,1) == dis(:,2) | dis(:,1) == 0 | dis(:,2) == 0);
		if (length(ddx) > 0)
			error('here');
		end
		%[elem1(fdx,:) elem2(fdx,:)]
		tflag = false(obj.nelem,1);
		for idx=1:size(fdx,1)
			tdx_ = tdx(fdx(idx),:);
			% avoid dubplicate processing
			if (none(tflag(tdx_(:))))
				% disjoint vertices become common
				% and common vertices become disjoint
%		[com(fdx(idx),:), dis(fdx(idx),:)]
%		([obj.elem(tdx_(1),1:3) obj.elem(tdx_(2),1:3)])
				obj.elem(tdx_(1),1:3) = [dis(fdx(idx),:), com(fdx(idx),1)];
				obj.elem(tdx_(2),1:3) = [dis(fdx(idx),:), com(fdx(idx),2)];
				tflag(tdx_(:)) = true;
%		([obj.elem(tdx_(1),1:3) obj.elem(tdx_(2),1:3)])
		%[obj.elem(tdx_(1),1:3) obj.elem(tdx_(2),1:3)]
			end
		%tdx
		%[obj.elem(tdx_(1),1:3) obj.elem(tdx_(2),1:3)]
			obj.check_dublicate_elements();
		end % for idx
		% lazy recomputation
		obj.edges_from_elements();
		iter = iter+1;
	end % while 1
end % flip_global

