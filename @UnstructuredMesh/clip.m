% Sa 14. Nov 16:21:22 CET 2015
% Fri 27 May 09:10:59 CEST 2016
% Fri  8 Nov 11:11:11 +08 2019
% Karl Kastner, Berlin
%
%% clip mesh to polygonal domain 
%% TODO only works for triangles
function [sid,obj] = clip(obj,pxy)

	x = [pxy(1:end-1,1),pxy(2:end,1)];
	y = [pxy(1:end-1,2),pxy(2:end,2)];

	[pxy_,sid,fdx] = obj.section(x,y);

	np  = obj.np;
	pid = np+(1:size(pxy_,1));
	obj.point(pid,:) = pxy_; %(fdx,:);

	% closure
	% for each split edge
	% for each adjacent element
	% determine which point is opposite
	o     = zeros(3*obj.nelem,1);
	nelem = obj.nelem;

	% each edge has 2 adjacent elemnts
	% TODO, this can be avoided by storing which edge of the element it is
	edx = obj.edge(fdx,:);
	for idx=1:2
		% ldx is not unique
		ldx  = obj.edge2elem(fdx,idx);
		f = ldx>0;
		ldx_ = ldx(f); % ignore bnd
		elem = obj.elem(ldx_,:);
		% index of vertex opposit of splitted edge
		col = ((5 -   (bsxfun(@eq,elem(:,1),edx(f,1)) | bsxfun(@eq,elem(:,1),edx(f,2))) ...
			  - 2*(bsxfun(@eq,elem(:,2),edx(f,1)) | bsxfun(@eq,elem(:,2),edx(f,2))) ...
			  - 3*(bsxfun(@eq,elem(:,3),edx(f,1))|bsxfun(@eq,elem(:,3),edx(f,2)))));
		ldx_    = ldx_ + nelem*col;
		o(ldx_) = pid(f);
	end
	o = reshape(o,[],3);

	% unique indices of split elements
	ldx = find(sum(o,2) > 0);
	[elem1,elem2,elem3] = tesselate2(obj.elem(ldx,:),o(ldx,:));
	% replace old element
	obj.elem(ldx,:) = elem1;
	% add new elements
	obj.elem(end+1:end+2*length(ldx),:) = [elem2;elem3];	

	% remove outside elements
	% TODO make this elements a second mesh
	disp('removing elements outside of the domain');
	[cxy]     = obj.element_midpoint();
	in        = Geometry.inPolygon(pxy(:,1),pxy(:,2),cxy(:,1),cxy(:,2));
	obj.elem  = obj.elem(in,:);

	[ddx,pdx] = obj.remove_isolated_vertices();
	for idx=1:length(sid)
		sid{idx} = pdx(sid{idx}+np);
	end
	obj.edges_from_elements();
	% restore delaunay condition
	disp('restoring delaunay property');
	obj.flip_global();

%X = obj.X;
%Y = obj.Y;
%	hold on
%	p = patch(X(elem1)',Y(elem1)',zeros(size(elem1,1),1)');
%	p.FaceColor = 'r';
%	p = patch(X(elem2)',Y(elem2)',zeros(size(elem2,1),1)');
%	p.FaceColor = 'g';
%	p = patch(X(elem3)',Y(elem3)',zeros(size(elem3,1),1)');
%	p.FaceColor = 'b';
end % crop

% blue tesselation (2 edges split)
function [elem1,elem2,elem3] = tesselate2(elem,o)
	% there are three cases for intersected elements
	% edges split as AB, AC or BC
	for idx=1:3
		fdx   = (0 == o(:,1));
		elem1(fdx,:) = [elem(fdx,1),o(fdx,3),o(fdx,2)];
		% TODO, there are 2 variants, choose variant with shorter edge
		elem2(fdx,:) = [elem(fdx,3),o(fdx,2),o(fdx,3)];
		elem3(fdx,:) = [elem(fdx,2),elem(fdx,3),o(fdx,3)];
		% shift
		elem = [elem(:,2:3),elem(:,1)];
		o    = [o(:,2:3),o(:,1)];
	end
end % tesselate2

