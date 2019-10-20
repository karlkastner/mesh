% Sat 26 May 13:38:59 CEST 2018
% Karl Kästner, Berlin
%% lump sequentially sampled data "v0" and assign to field "field"
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

