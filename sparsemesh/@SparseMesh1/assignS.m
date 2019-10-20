% Mon 28 May 18:28:47 CEST 2018
% Karl Kästner, Berlin
%% lump sequentially sampled data "v0" and assign to field "field"
%% 
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
		% simple averaging, split data in blocks of equal lenght
		% for each block
		for idx=1:m:obj.n
			% for each ensemble in the block
			for jdx=1:m
				k = k+1;
				if (last(k)>1)
					% TODO use special transformation
					v0m(:,jdx) = interp1(S(1:last(k),k),v0(1:last(k),k),obj.S0,'linear','extrap');
				else
					v0m(:,jdx) = NaN;
				end
			end
			% average profiles
			obj.val.(field)(:,idx) = obj.mfun(v0m,2);
		end % for idx
	else
		% TODO, this is broken, "last" needs to be stored in obj 
		v0m = zeros(length(obj.S0),obj.n0,class(v0));
		% resample
		for k=1:obj.n0
			% TODO, check that input data is finite
			% TODO, this is not well conditioned for noisy data and dx_sample << dx_resample
			% better: get all samples belonging to block id and do a linear least squares regression
			v0m(:,k) = interp1(S(1:last(k),k),v(1:last(k),k),obj.S0,'linear','extrap');
		end
		for idx=1:length(obj.S0)
			obj.val.field(idx,:) =  accumarray(obj.id,v0m(idx,:),[obj.n+1,1],obj.mfun,NaN(class(v0)));
		end
	end
end % assignS

