% Mon 28 May 18:28:47 CEST 2018
classdef SparseMesh1 < SparseMesh
	properties
	end % properties
	methods
		function obj = SparseMesh1(varargin)
			obj.S = 1;
			for idx=1:2:length(varargin)-1
				obj.(varargin{idx}) = varargin{idx+1};
			end
		end

		function init(obj,X)
			obj.n0         = size(X,1);
			%if (nargin()<5)
				field = 'default';
			%end
			% re-initialize data
			obj.val = struct();
			% normalize S
			obj.S = obj.S/norm(obj.S);

			obj.fdx = isfinite(X);
			X = X(obj.fdx);
			if (isempty(obj.dxmax))
				obj.n          = ceil(obj.n0/obj.m);
				m = obj.m;
				X(end+1:obj.n*m,:) = NaN;
				x1         = reshape(X,m,obj.n);
				x1c        = obj.mfun(x1).';
			else
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

		function obj = assign(obj,field,v0)
			if (length(v0) ~= obj.n0)
				error('length missmatch');
			end
			if (isempty(obj.dxmax))
				v0 = v0(obj.fdx);
				v0(end+1:obj.n*obj.m) = NaN;
				v0              = reshape(v0,obj.m,obj.n);
				v               = obj.mfun(v0);
			else
				v = accumarray(obj.id,v0,[obj.n+1,1],obj.mfun,NaN(class(v0)));
				
			end
			obj.val.(field) = v;
		end

		function obj = assignS(obj,field,v0,S)
			v0 = v0(:,obj.fdx);
			if (length(v0) ~= obj.n0)
				error('length missmatch');
			end
			obj.val.(field) = NaN(length(obj.S0),obj.n,class(v0));
			v0(end+1:obj.n*obj.m,:) = NaN;
			k   = 0;
			v0m = NaN(length(obj.S0),obj.n+1,class(v0));
			if (isempty(obj.dxmax))
			% for each block
			for idx=1:m:obj.n
				% for each ensemble in the block
				for jdx=1:m
					k = k+1;
					if (last(k)>1)
						% TODO use special transformation
						v0m(:,jdx) = interp1(S(1:last(k),k),v(1:last(k),k),obj.S0,'linear','extrap');
					else
						v0m(:,jdx) = NaN;
					end
				end
				% average profiles
				obj.val.(field)(:,idx) = obj.mfun(v0m,2);
			end % for idx
			else
				v0m = zeros(length(obj.S0),obj.n0,class(v0));
				% resample
				for k=1:obj.n0
					v0m(:,k) = interp1(S(1:last(k),k),v(1:last(k),k),obj.S0,'linear','extrap');
				end
				for idx=1:length(obj.S0)
					obj.val.field(idx,:) =  accumarray(obj.id,v0m(idx,:),[obj.n+1,1],obj.mfun,NaN(class(v0)));
				end
			end
		end % assignS

		function meshplot(obj,field,varargin)
			%trimesh(obj.T.ConnectivityList,obj.T.Points(:,1),obj.T.Points(:,2),[],obj.val.(field));
			if (isstr(field))
				v  = obj.val.(field);
			else
				v = field;
			end
			plot(obj.T.x(obj.T.sdx),v(obj.T.sdx),varargin{:});
		end

		function [s,s2] = rmse(obj,field)
			v  = obj.val.(field)(obj.T.sdx); %obj.val.(field)(obj.T.ConnectivityList(:,:));
			dv = 1/2*cdiff(v,2);
			%s2 = var(v.');
			s  = sqrt(mean(s2));
		end

		function vi = interp(obj,field,Xi)
			% allocate memory
			%vi      = NaN(size(Xi));
			x = obj.T.x(obj.T.sdx);
			v = obj.val.(field)(obj.T.sdx);
			% interpolate
			% ignore missing
			fdx = isfinite(v);
			vi = interp1(x(fdx),v(fdx),Xi,'linear',NaN);
		end % interp

		function v = interpS(obj,field,Xi)
			n = size(Xi,1);
			% allocate memeory
			%vi   = NaN(length(obj.S0),n);
			
			v = interp1(obj.T.x,obj.val.(field),Xi,'linear',NaN);
		end % interpS

		function val = filter(obj,field,nf)
			val = obj.val.(field)(obj.T.sdx);
			fdx = isfinite(val);
			val(fdx) = medfilt1(val(fdx),nf);
			val(obj.T.sdx) = val;
			obj.val.(field) = val;
		end % filter
	end % methods
end % class SparseMesh1

