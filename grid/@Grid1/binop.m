%Tue Jul 22 16:38:54 WIB 2014
% Karl Kastner, Berlin
%% operate function fun on data val within the context of a grid cell
%% (for fitting grid cell values from sampled values)
function [varargout] = binop(obj,idfield,fun,val,varargin)
	no = nargout;
	ni = length(varargin);
	[vo{1:no}] = arrayfun(@(id) binop_(id), ...
				obj.id.(idfield).id, 'uniformoutput', false);
	for idx=1:no
		vo{idx} = cell2mat(cellfun(@(x) (rvec(x)),vo{idx},'uniformoutput',false));
	end
	varargout = vo;

	function varargout = binop_(id)
		v = cell(1,ni);
		for idx=1:ni;
			v{idx} = varargin{idx}(id.id);
		end
		[varargout{1:no}] = fun(val(id.id),v{:});
	end % binop_
end % binop


