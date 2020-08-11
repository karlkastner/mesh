% Wed 23 May 14:09:46 CEST 2018
% Sat 19 May 18:59:14 CEST 2018
%%
%% smooth the mesh coordinates
% TODO invalid points for complex domains
function obj = smooth_simple(obj,val,dim,p,n,nk,keepends)
	reshaped = false;
	if (nargin() < 2)
		val = [];
	else
		if (isvector(val))
			val = reshape(val,obj.n);
			reshaped = true;
		end
	end
	if (nargin() < 3 || isempty(dim))
		dim = [1,1];
	end
	if (nargin() < 4)
		p = 0.5;
	end
	if (nargin() < 5)
		n = 1;
	end
	if (nargin()<6)
		nk = 3;
	end
	if (nargin()<7)
		keepends = false;
	end
%	for idx=1:n
	switch (dim(1)+2*dim(2))
	case {1} % 1 0
		if (isempty(val))
			obj.X = cmean(obj.X,1,p,n,nk,keepends);
			obj.Y = cmean(obj.Y,1,p,n,nk,keepends);
		else
			val = cmean(val,1,p,n,nk,keepends);
		end
	case {2} % 0 1
		if (isempty(val))
			obj.X = cmean(obj.X,2,p,n,nk,keepends);
			obj.Y = cmean(obj.Y,2,p,n,nk,keepends);
		else	
			% csmooth?
			val   = cmean(val,2,p,n,nk,keepends);
		end
	case {3}
		if (isempty(val))
			obj.X = cmean2(obj.X,p,n,nk,keepends);
			obj.Y = cmean2(obj.Y,p,n,nk,keepends);
		else	
			val   = cmean2(val,p,n,nk,keepends);
		end
	otherwise
		error('invaild dimension');
	end
	if (reshaped)
		val = flat(val);
	end
end % smooth_simple

