% Sun Jan  5 18:02:11 WIB 2014
% Karl Kastner, Berlin
function obj = build_index(obj,X1,X2,X3)
	% allocate memory
	obj.val = zeros(obj.n1,obj.n2,obj.n3,size(val,2),'single');
	m = zeros(obj.n1,obj.n2,obj.n3,size(val,2),'single');
	% get n coordinate
		%ndx = floor(N*(obj.nn-1)+1.5);
	x1   = (X1 - obj.X1(1))/(obj.X1(end)-obj.X1(1));
	ndx1 = floor(x1*(obj.n1-1)+1.5);
	% get z coordinate
	x2 = (X2 - obj.X2(1))/(obj.X2(end)-obj.X2(1));
	ndx2 = floor(x2*(obj.n2-1)+1.5);
		%x2 = (Z - obj.Z(1))/(obj.Z(end)-obj.Z(1));
		%zdx = floor(s*(obj.nz-1)+1.5);
	% get t coordinate
	x3   = (X3 - obj.X3(1))/(obj.X3(end)-obj.X3(1));
	ndx3 = floor(x3*(obj.n3-1)+1.5);
	% find valid indices
	fdx = find(ndx1 > 0 & ndx1 <= obj.n1 ...
		 & ndx2 > 0 & ndx2 <= obj.n2 ...
		 & ndx3 > 0 & ndx3 <= obj.n3);
	%	full(sparse(ndx,zdx,bin.val
	%val_vdx = val{vdx};
%		for idx=fdx(:)'
	ndx1 = ndx1(fdx);
	ndx2 = ndx2(fdx);
	ndx3 = ndx3(fdx);
	val = val(fdx,:);
	javaaddpath('.');
	bin = javaObject('Bin');
	for vdx=1:size(val,2)
		bin.bin3(int32(ndx1),int32(ndx2),int32(ndx3),val(:,vdx),zeros(obj.n1,obj.n2,obj.n3));
		obj.val(:,:,:,vdx) = bin.bin3_;
		bin.bin3(int32(ndx1),int32(ndx2),int32(ndx3),ones(size(val(:,vdx))),zeros(obj.n1,obj.n2,obj.n3));
		m(:,:,:,vdx) = bin.bin3_;
		%obj.val(ndx1(idx),ndx2(idx),ndx3(idx),vdx) = obj.val(ndx1(idx),ndx2(idx),ndx3(idx),vdx) + val(idx,vdx);
		%m(ndx1(idx),ndx2(idx),ndx3(idx),vdx) = m(ndx1(idx),ndx2(idx),ndx3(idx),vdx) + 1;
	end % idx
	%obj.val(ndx1(idx),ndx2(idx),ndx3(idx),:) = obj.val(ndx1(idx),ndx2(idx),ndx3(idx),:) + val(idx,:);
%		end % fdx
	obj.val = obj.val./m;
end % build_index

