% Sat 26 May 13:38:59 CEST 2018
classdef SparseMesh2 < SparseMesh
	properties
	end
	methods
		function obj = SparseMesh2()
			obj.S = [1,1];
		end

		function init(obj,X)
			if (nargin()<5)
				field = 'default';
			end
			% re-initialize data
			obj.val = struct();
			% normalize S
			obj.S = obj.S/norm(obj.S);

			obj.fdx = all(isfinite(X),2);
			X = X(obj.fdx,:);

			% TODO, mahalanobis
			obj.n0         = size(X,1);
			obj.n          = ceil(obj.n0/obj.m);
			m = obj.m;
			X(end+1:obj.n*m,:) = NaN;

			x1     = reshape(X(:,1),m,obj.n);
			x1c    = nanmean(x1).';
			x2     = reshape(X(:,2),m,obj.n);
			x2c    = nanmean(x2).';
			obj.T = delaunayTriangulation(obj.S(1)*x1c,obj.S(2)*x2c);
		end %

		function obj = assign(obj,field,v0)
			v0 = v0(obj.fdx,:);
			if (length(v0) ~= obj.n0)
				error('length missmatch');
			end
			v0(end+1:obj.n*obj.m) = NaN;
			v0              = reshape(v0,obj.m,obj.n);
			obj.val.(field) = obj.mfun(v0);
			%obj.val.(field) = nanmedian(v0).';
		end

		function obj = assignS(obj,field,S,v0,last)
			v0 = v0(:,obj.fdx);
			if (length(v0) ~= obj.n0)
				error('length missmatch');
			end
			m = obj.m;
			obj.val.(field) = NaN(length(obj.S0),obj.n);
			%v0(:,end+1:obj.n*obj.m) = NaN;
			k   = 0;
			v0m = NaN(length(obj.S0),obj.m,class(v0));
			% for each block
			for idx=1:obj.n
				% for each ensemble in the block
				for jdx=1:m
					k = k+1;
					if (k<=size(S,2) && last(k)>1)
						% TODO use special transformation
						v0m(:,jdx) = interp1(S(1:last(k),k),v0(1:last(k),k),obj.S0,'linear','extrap');
					else
						v0m(:,jdx) = NaN;
					end
				end
				% average profiles
				obj.val.(field)(:,idx) = obj.mfun(v0m,2);
			end % for idx
		end % assignS

		function meshplot(obj,field,varargin)
			%trimesh(obj.T.ConnectivityList,obj.T.Points(:,1),obj.T.Points(:,2),[],obj.val.(field));
			if (isstr(field))
				v  = obj.val.(field);
			else
				v = field;
			end
			trisurf(obj.T.ConnectivityList, ...
				obj.T.Points(:,1),obj.T.Points(:,2),[],v, ...
				'edgecolor','none', varargin{:});
			view(0,90);
		end

		function [s,s2]  = rmse(obj,field)
			v  = obj.val.(field)(obj.T.ConnectivityList(:,:));
			s2 = var(v.');
			s  = sqrt(mean(s2));
		end

		function vi = interp(obj,field,Xi)
			n = size(Xi,1);
			% allocate memeory
			vi   = NaN(n,1);
			% get triangle index and barycentric coordinates
			[tid,B] = obj.T.pointLocation(obj.S(1)*Xi(:,1),obj.S(2)*Xi(:,2));
			% select interior points
			fdx = isfinite(tid);
			% get vertex indices
			pid = obj.T.ConnectivityList(tid(fdx),:);
			% get values at vertices
			vp = obj.val.(field)(pid);
			% interpolate with barycentric coordinates
			%vi(fdx) = B(fdx,:)*vp.';
			vi(fdx) = sum((B(fdx,:).*vp)').';
		end % interp
		
		function v = interpS(obj,field,Xi)
			n = size(Xi,1);
			% allocate memeory
			v    = NaN(length(obj.S0),n);
			% get triangle index and barycentric coordinates
			[tid,B] = obj.T.pointLocation(obj.S(1)*Xi(:,1),obj.S(2)*Xi(:,2));
			% select interior points
			fdx = isfinite(tid);
			% get vertex indices
			pid = obj.T.ConnectivityList(tid(fdx),:);

			% get values at vertices and interpolate
			v(:,fdx) = ( bsxfun(@times,B(fdx,1).', obj.val.(field)(:,pid(:,1))) ...
			           + bsxfun(@times,B(fdx,2).', obj.val.(field)(:,pid(:,2))) ...
			           + bsxfun(@times,B(fdx,3).', obj.val.(field)(:,pid(:,3))) );
		end % interpS
	end % methods
end % class SparseMesh2

