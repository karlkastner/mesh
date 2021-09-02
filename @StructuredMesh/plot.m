% Wed 21 Feb 17:29:54 CET 2018
%% plot the mesh
function obj = plot(obj,val,opt)
	if (nargin()<3)
		opt = struct();
	end
	if (~isfield(opt,'edgecolor'))
		opt.edgecolor = 'k';
	end
	if (~isfield(opt,'boundary'))
		opt.boundary = false;
	end
	if (~isfield(opt,'xlabel'))
		opt.xlabel = 'x';
	end
	if (~isfield(opt,'ylabel'))
		opt.ylabel = 'y';
	end

	v  = full([flat(obj.X),flat(obj.Y)]);
	if (nargin()<2||isempty(val))
		patch('faces',obj.elem,		...
			'vertices',v, ...
			'facecolor','none', ...
			'edgecolor',opt.edgecolor);
	else
		val = squeeze(val);
		if (isvector(val))
			switch (length(val))
			case {prod(obj.n)}
				val = reshape(val,obj.n);
			case {prod(obj.n-1)}
				val = reshape(val,obj.n-1);
			otherwise
				error('here');
			end
		end

%		val = flat(val(2:end,2:end)); 
%		val = [val, val(:,end)];
%		val = [val; val(end,:)];
		val = flat(val);
		switch (length(val))
		case {size(obj.elem,1)}
			imethod = 'flat';
		case {numel(obj.X)}
			imethod = 'interp';
			v(:,3) = val;
		otherwise
			error('here')
		end
	
%		size(flat(val))
%		size(v)
%		pause
		%val = val-min(val(:));
		%val = val/max(val(:));
%'honk'
		patch(  'faces', obj.elem, ...
			'vertices', v, ...
			'CData', val, ...
			... 'FaceVertexCData', val, ...
			... %'FaceColor', 'interp', ...
			'FaceColor', imethod, ...
			'edgecolor', 'none');
%pause
%		else
%		end

	end
		hold on
		if (isfield(opt,'number') && opt.number)
			for idx=1:size(obj.X,1)
				text(obj.X(idx,1),obj.Y(idx,1),num2str(idx));
			end	
			for idx=1:size(obj.X,2)
				text(obj.X(1,idx),obj.Y(1,idx),num2str(idx));
			end	
		end
	xlabel(opt.xlabel)
	ylabel(opt.ylabel);
	n = size(obj.X);
%	n =[2,2;
 %           2,n(2)-1;
  %          n(1)-1,2
   %         n(1)-1,n(2)-1];
	% boundary
	if (opt.boundary)
	bnd = obj.boundary_chain();
	X = obj.X;
	Y = obj.Y;
	hold on
	plot([X(bnd(:,1)),X(bnd(:,2)),NaN(size(bnd,1),1)]',[Y(bnd(:,1)),Y(bnd(:,2)),NaN(size(bnd,1),1)]','r');
	plot([X(bnd(:,1)),X(bnd(:,3)),NaN(size(bnd,1),1)]',[Y(bnd(:,1)),Y(bnd(:,3)),NaN(size(bnd,1),1)]','r');
	end

	if (isfield(opt,'index'))
	switch (opt.index)
	case {'boundary'}
		X = obj.X;
		Y = obj.Y;
		for idx=1:size(X,1)
			text(obj.X(idx,1),obj.Y(idx,1),num2str(idx));
			text(obj.X(idx,end),obj.Y(idx,end),num2str(idx));
		end
		for idx=1:size(X,2)
			text(obj.X(1,idx),obj.Y(1,idx),num2str(idx));
			text(obj.X(end,idx),obj.Y(end,idx),num2str(idx));
		end
	case {'corner'}	
		id = obj.corner_indices();
		for idx=1:size(id,1)
		text(obj.X(id(idx,1),id(idx,2)),100*(rand())+obj.Y(id(idx,1),id(idx,2)),sprintf('%d,%d',id(idx,1:2)));
		text(obj.X(id(idx,3),id(idx,4)),100*(rand())+obj.Y(id(idx,3),id(idx,4)),sprintf('%d,%d',id(idx,3:4)));
		%text(obj.X(n(idx,1),n(idx,2)),obj.Y(n(idx,1),n(idx,2)),sprintf('%d,%d',n(idx,:)));
		%text(obj.X(end,end),obj.Y(end,end),sprintf('%d,%d',n));
		end
	end % switch
	end % if
end

