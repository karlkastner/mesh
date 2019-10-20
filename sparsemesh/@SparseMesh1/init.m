% Mon 28 May 18:28:47 CEST 2018
% Karl Kästner, Berlin
%% initialize, segment sampling locations/times into blocks the sampled
%% data is lumped to
function init(obj,X)
	obj.n0 = size(X,1);
	field  = 'default';

	% re-initialize data
	obj.val = struct();

	% normalize S
	obj.S = obj.S/norm(obj.S);
	
	obj.fdx = isfinite(X);
	X       = X(obj.fdx);
	if (isempty(obj.dxmax))
		% lumping into blocks with distinct number of samples
		obj.n      = ceil(obj.n0/obj.m);
		m          = obj.m;
		X(end+1:obj.n*m,:) = NaN;
		x1         = reshape(X,m,obj.n);
		x1c        = obj.mfun(x1).';
	else
		% lumping into blocks of distinc length
		id = zeros(length(X),1);
		S  = [0;cumsum(abs(diff(X)))];
		k  = 1;
		last = 1;
		for idx=1:length(X)
			if (S(idx)-S(last) > obj.dxmax)
				k = k+1;
				last = idx;
			end
			id(idx) = k;
		end % for idx
		obj.n = k;
		id(0 == idx) = k+1;
		x1c = accumarray(id,X,[obj.n+1,1],obj.mfun,NaN(class(X)));
		obj.id      = (obj.n+1)*ones(obj.n0,1);
		obj.id(obj.fdx) = id;
		%x1c = arrayfun(	obj.mfun)
	end
	
	[void,sdx]  = sort(x1c);
	obj.T.sdx  = sdx;
	obj.T.x    = x1c;
end % init

