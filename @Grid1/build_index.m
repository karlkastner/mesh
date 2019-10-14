% Sun Jan  5 18:02:11 WIB 2014
% Karl Kastner, Berlin
%
% name : name of the index field
% X1 : coordinate of source points
% R  : cut off radius (if not supplied ident to mesh width)
function obj = build_index(obj,X1,name,R)
	% alocate memory
	m = zeros(obj.n1-1,1,'single');
	id(obj.n1-1,1).id = zeros(0,'single');

	if (nargin() < 3 || isempty(name))
		name = 'default';
	end

	if (nargin() < 4 || isempty(R))
		% standard mesh, no overlap
		ndx1_ = NaN(size(X1));
	
		% normalise coordinate
		x1   = (X1 - obj.X1(1))/(obj.X1(end)-obj.X1(1));
		ndx1 = round(x1*(obj.n1-2)+0.5);
		% find valid indices
		fdx = find(ndx1 > 0 & ndx1 <= obj.n1-1);
		% TODO this can be done with the sparse function
		% TODO compute m first and preallocate then
		% accumulate values
		for idx=fdx(:)'
			m(ndx1(idx)) = m(ndx1(idx)) + 1;
			id(ndx1(idx)).id(end+1) = idx;
		end
		% backward index
		ndx1_(fdx) = ndx1(fdx);
	else
		% TODO use varargin to avoid confusion
		R2  = R*R;
		cX1 = obj.cX1;
		for idx=1:obj.n1-1
			D  = X1-cX1(idx);
			D2 = D.*D;
			fdx = find(D2 < R2);
			m(idx)     = length(fdx);
			id(idx).id = fdx;
		end
		% The bw index is not unique for Rz0 <> dx1, so leave empty
		ndx1_ = [];
	end
	obj.id.(name).m   = m;
	obj.id.(name).id  = id;
	obj.id.(name).rid = ndx1_;
end % function buid_index

