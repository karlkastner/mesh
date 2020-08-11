% Di 27. Okt 22:37:40 CET 2015
% Karl Kastner, Berlin
%
%% plot the mesh (and a discretised function) as a surface and net
%
function [ph, obj] = plot(obj,pval,opt)
	ih   = ishold();

	% fetch
	x    = real(obj.X);
	y    = real(obj.Y);
	if (nargin() < 2 || isempty(pval))
		if (size(obj.point,2) > 2)
			z = obj.point(:,3);
		else
 			z = ones(length(x),1);
		end
	else
		z = pval;
	end
	
	z     = double(z);
	if (isvector(z))
		z = cvec(z);
	else
		% if Z is a vector-valued make it scalar
		z = mean(z,2);
	end
	edge  = double(obj.edge);
	bnd   = obj.bnd;	

	if (nargin() < 3 || isempty(opt))
		opt = struct();
	end
	if (~isfield(opt,'surface'))
		opt.surface = true;
	end
	if (~isfield(opt,'elem_edgecolor'))
		opt.elem_edgecolor = 'none';
	end
	if (~isfield(opt,'boundary'))
		opt.boundary = false;
	end
	if (~isfield(opt,'boundary_color'))
		opt.boundary_color = 'r';
	end
	if (~isfield(opt,'edges'))
		opt.edges = false;
	end
	if (~isfield(opt,'edgecolor'))
		opt.edgecolor = 'k';
	end
	if (~isfield(opt,'edges_individual'))
		opt.edges_individual = false;
	end
	if (~isfield(opt,'points'))
		opt.points = false;
	end
	if (~isfield(opt,'surfarg'))
		opt.surfarg = {};
	end
	if (~isfield(opt,'edgearg'))
		opt.edgearg = {};
	end
	[elem3, fdx3] = obj.elemN(3);
	elem3 = double(elem3);

	% plot elements
	if (opt.surface)
		% 1d elements a plotted later on top

		if (~isempty(elem3))
			switch (length(z))
			case {obj.np}
				% values given at points
	%		if (length(z) ~= obj.nelem)
				% value given on vertices
				ph = trisurf(elem3,x,y,z, ...
					'Edgecolor',opt.elem_edgecolor, ...
					'Facecolor','interp', ...
					opt.surfarg{:});
			case {obj.nedge}
				patch(  'faces',elem3, ...
					'vertices',[x, y], ...
					... % 'FaceVertexCData',z(fdx3),  ...
					'FaceColor','none', ...
					... % 'Edgecolor','none', ...
					opt.surfarg{:} );
				hold on
				x_ = mean(x(obj.edge),2);
				y_ = mean(y(obj.edge),2);
				%scatter(x_,y_,[],z);
				%scatter3(x_,y_,z,[],z,'.');
				scatter(x_,y_,[],z,'.');
			case {obj.nelem}
				% value given on elements
				patch('faces',elem3, ...
					'vertices',[x y], ...
					'FaceVertexCData',z(fdx3),  ...
					'FaceColor','flat', ...
					'Edgecolor','none', ...
					opt.surfarg{:} );
			otherwise
				error('here');
			end
			view([0,90]);
			hold on
		end
		for idx=4:size(obj.elem,2)
			[elem fdxi] = obj.elemN(idx);	
			elem = double(elem);
			if (~isempty(elem))
				if (length(z) ~= obj.nelem)	
					patch(  'faces',elem, ...
						'vertices',[x y z], ...
						'FaceVertexCData', z,  ...
						'Edgecolor','none', ...
						'Facecolor','interp', ...
						opt.surfarg{:});
				else
					patch(  'faces',elem, ...
						'vertices',[x y z], ...
						'FaceVertexCData',z(fdxi), ...
						'FaceColor','flat', ...
						'Edgecolor','none', ...
						opt.surfarg{:} );
				end % if
			end % if
			hold on
		end % for
		% always plot 1d elements as lines
		elem2 = obj.elemN(2);
		if (~isempty(elem2))
			plot(x(elem2)',y(elem2)','-k');
			hold on
		end
	end % surface

	% edges
	if (opt.edges)

		elem2 = obj.elemN(2);
		if (~isempty(elem2))
			plot(x(elem2)',y(elem2)','r')
		end

		if (~isempty(elem3))
%			triplot(double(elem3),x,y, ...
%				'Color','k', ...
%				opt.edgearg{:});
				z_ = zeros(size(x));
				patch(  'faces',elem3, ...
					'vertices',[x y z_], ... % z], ...
					... 'FaceVertexCData',z, ...
					'FaceColor','none', ...
					'EdgeColor',opt.edgecolor, ...
				        opt.edgearg{:});
		end
		for idx=4:size(obj.elem,2)
			elem = obj.elemN(idx);	
			if (~isempty(elem))
				patch(  'faces',elem, ...
					'vertices',[x y], ...
					'FaceColor','none', ...
					'EdgeColor','k', ...
				        opt.edgearg{:});
			end % if
		end % for 
		hold on
	end % edges

	% 1D nodal points and end points
	elem = obj.bnd_1d();
	if (~isempty(elem))
		plot(obj.X(elem(:,1)),obj.Y(elem(:,1)),'ro');
	end
	fdx = obj.vertices_1d();
	if (~isempty(fdx))
		plot(obj.X(fdx),obj.Y(fdx),'go');
	end
	try
	[Xc Yc X Y Z] = cross_section(obj);
	if (~isempty(X))
		plot(X',Y','k');
	end
	catch
	end

	if (opt.edges_individual)
		edge = obj.edge;
	%	size(edge)
	%	pause
	%	size(x)
	%	for idx=1:size(edge,1)
	%		idx
	%		plot(x(edge(idx,:)),y(edge(idx,:)))
	%		hold on;
	%		pause(1)
	%	end
		plot(x(edge'),y(edge'),'k')
		%plot(x(edge),y(edge),'k')
		%plot(x(edge)',y(edge)','k')
	end

	% boundary
	if (opt.boundary)
		xx      = x(edge(bnd,:));
		xx(:,3) = NaN;
		yy      = y(edge(bnd,:));
		yy(:,3) = NaN;
		%plot(x(edge(bnd,:)'),y(edge(bnd,:)'),opt.boundary_color);
		plot(flat(xx.'),flat(yy.'),opt.boundary_color);
	end

	% points
	if (opt.points)
		plot(x',y','k.');
	end

	if (~ih)
		hold off;
	end
end % UnstructuredMesh/plot()

