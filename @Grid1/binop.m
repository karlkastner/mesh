%Tue Jul 22 16:38:54 WIB 2014
% Karl Kastner, Berlin

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

%	func = obj.func;
%	varargout{end+1} 
%
%	switch (nargout)
%	case {1}
%		switch (length(varargin))
%		case {1}
%			valo1 = arrayfun(@(id) func(varargin{1}(id.id)), obj.id.(fieldname).id,'uniformoutput',false);
%		case {2}
%			valo1 = arrayfun(@(id) func(varargin{1}(id.id),varargin{2}(id.id)), obj.id.(fieldname).id,'uniformoutput',false);
%		case {3}
%			valo1 = arrayfun(@(id) func(   varargin{1}(id.id) ...
%                                                     , varargin{2}(id.id) ...
%                                                     , varargin{3}(id.id)) ...
%                                                     , obj.id.(fieldname).id,'uniformoutput',false);
%		case {4}
%			valo1 = arrayfun(@(id) func(   varargin{1}(id.id) ...
%                                                     , varargin{2}(id.id) ...
%                                                     , varargin{3}(id.id) ...
%                                                     , varargin{4}(id.id)) ...
%                                                     , obj.id.(fieldname).id,'uniformoutput',false);
%		case {5}
%			valo1 = arrayfun(@(id) func(   varargin{1}(id.id) ...
%                                                     , varargin{2}(id.id) ...
%                                                     , varargin{3}(id.id) ...
%                                                     , varargin{4}(id.id) ...
%                                                     , varargin{5}(id.id)) ...
%                                                     , obj.id.(fieldname).id,'uniformoutput',false);
%		otherwise
%			error('not yet implemented');
%		end
%		valo1 = cell2mat(cellfun(@(x) (rvec(x)),valo1,'uniformoutput',false));
%		varargout = {valo1, obj};
%	case {2}
%		switch (length(varargin))
%		case {1}
%			[valo1 valo2] ...
%				    = arrayfun(@(id) func(   varargin{1}(id.id)) ...
%                                                           , obj.id.(fieldname).id ...
%                                                           , 'uniformoutput', false);
%		case {2}
%			[valo1 valo2] ...
%			             = arrayfun(@(id) func(  varargin{1}(id.id) ...
%                                                           , varargin{2}(id.id)) ...
%                                                           , obj.id.(fieldname).id,'uniformoutput',false);
%		case {3}
%			[valo1 valo2] ...
%			             = arrayfun(@(id) func(  varargin{1}(id.id) ...
%                                                           , varargin{2}(id.id) ...
%                                                           , varargin{3}(id.id)) ...
%                                                           , obj.id.(fieldname).id,'uniformoutput',false);
%		case {4}
%			[valo1 valo2] ...
%			             = arrayfun(@(id) func(  varargin{1}(id.id) ...
%                                                           , varargin{2}(id.id) ...
%                                                           , varargin{3}(id.id) ...
%                                                           , varargin{4}(id.id)) ...
%                                                           , obj.id.(fieldname).id,'uniformoutput',false);
%		case {5}
%			[valo1 valo2] ...
%			             = arrayfun(@(id) func(  varargin{1}(id.id) ...
%                                                           , varargin{2}(id.id) ...
%                                                           , varargin{3}(id.id) ...
%                                                           , varargin{4}(id.id) ...
%                                                           , varargin{5}(id.id)) ...
%                                                           , obj.id.(fieldname).id,'uniformoutput',false);
%		case {6}
%			[valo1 valo2] ...
%			             = arrayfun(@(id) func(  varargin{1}(id.id) ...
%                                                           , varargin{2}(id.id) ...
%                                                           , varargin{3}(id.id) ...
%                                                           , varargin{4}(id.id) ...
%                                                           , varargin{5}(id.id) ...
%                                                           , varargin{6}(id.id)) ...
%                                                           , obj.id.(fieldname).id,'uniformoutput',false);
%		otherwise
%			error('not yet implemented');
%		end
%		valo1 = cell2mat(cellfun(@(x) (rvec(x)),valo1,'uniformoutput',false));
%		valo2 = cell2mat(cellfun(@(x) (rvec(x)),valo2,'uniformoutput',false));
%		varargout = {valo1, valo2, obj};
%		varargout = {valo1, valo2, obj};
%	otherwise
%		error('not yet implmented');
%	end % switch nargin
%	%varargout{nargout+1} = obj;


%end % binop
