% Sun Jan  5 18:02:11 WIB 2014
% Karl Kastner, Berlin
function obj = build_index(obj,X1,X2,name)
		% allocate memory
		% count of samples per cell
		m = zeros(obj.n1-1,obj.n2-1,1,'single');
		% get n coordinate

		if (nargin()<4 || isempty(name))
			name = 'default';
		end
		x1   = (X1 - obj.X1(1))/(obj.X1(end)-obj.X1(1));
		ndx1 = round(x1*(obj.n1-2)+0.5);
		% get s coordinate (global s), X2 supplied as Z
		% ensemble max / grid column max
%		x2  = NaN(size(X2));
%		fdx = find(ndx1 > 0 & ndx1 <= obj.n1-1);
		% TODO quick hack for changing depth, as ndx1 is not known a priori
%		x2(fdx) = X2(fdx).*obj.lim2(ndx1(fdx))/abs(obj.X2(end)-obj.X2(1));
		%x2   = 1-X2/abs(obj.X2(end)-obj.X2(1)); % 2018
		x2   = (X2 - obj.X2(1))/abs(obj.X2(end)-obj.X2(1));
		%ndx2 = round(x2*(obj.n2-2)+0.5);
		% TODO why -2 and not -1 ?
		ndx2 = floor(x2*(obj.n2-2))+1;
		% find valid indices
		fdx = find(ndx1 > 0 & ndx1 <= obj.n1-1 & ndx2 > 0 & ndx2 <= obj.n2-1);
		% count
		m = single(full(sparse(double(ndx1(fdx)),double(ndx2(fdx)),ones(size(fdx)),obj.n1-1,obj.n2-1)));
		% preallocate
		id(obj.n1-1,obj.n2-1).id = zeros(0,'single');
		for idx=1:obj.n1-1
			for jdx=1:obj.n2-1
				id(idx,jdx).id = zeros(m(idx,jdx),1,'single');
			end
		end
		% assign
		m = 0.*m;
		for idx=fdx(:)'
			m(ndx1(idx),ndx2(idx)) = m(ndx1(idx),ndx2(idx)) + 1;
			id(ndx1(idx),ndx2(idx)).id(m(ndx1(idx),ndx2(idx))) = idx;
		end
		% counter
		obj.id.(name).m  = m;
		% forward index
		obj.id.(name).id = id;
		% backward index
		obj.ndx1      = NaN(size(X1));
		obj.ndx2      = NaN(size(X1));
		obj.ndx1(fdx) = ndx1(fdx);
		obj.ndx2(fdx) = ndx2(fdx);
end % build index

