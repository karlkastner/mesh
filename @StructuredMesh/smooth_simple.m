% Wed 23 May 14:09:46 CEST 2018
% Sat 19 May 18:59:14 CEST 2018
%%
%% smooth the mesh coordinates
% TODO invalid points for complex domains
function obj = smooth_simple(obj,val,dim,n)
	keepends = true;
	reshaped = false;
	if (nargin() < 2)
		val = [];
	else
		if (isvector(val))
			val = reshape(val,obj.n);
			reshaped = true;
		end
	end
	if (nargin() < 3)
		dim = [1,1];
	end
	if (nargin() < 4)
		n = 1;
	end
	for idx=1:n
	if (dim(1))
		if (isempty(val))
			% smooth mesh
			obj.X = cmean(obj.X,keepends);
			obj.Y = cmean(obj.Y,keepends);
		else
			val = cmean(val,keepends);
			% val = csmooth(val,varargin{:});
		end
	end
	if (dim(2))
		if (isempty(val))
			obj.X = cmean(obj.X',keepends)';
			obj.Y = cmean(obj.Y',keepends)';
		else	
			val = csmooth(val',varargin{:})';
		end
	end
	end
	if (reshaped)
		val = flat(val);
	end
end
