% Fri 12 Jan 16:24:22 CET 2018
%% plot mesh and values
function obj = plot3(obj,val,opt)
	if (nargin()<3)
		opt = struct();
	end
	if (~isfield(opt,'scatter'))
		opt.scatter = false;
	end

	X = obj.X;
	Y = obj.Y;
	Z = obj.Z;

	if (isfield(opt,'ctransform'))
		Z = opt.ctransform(X,Y,Z);
		%[X Y Z] = opt.ctransform(X,Y,Z);
	end

	elem = obj.elemN(4);

	if (nargin() < 2 || isempty(val))
		val = zeros(size(Z));
	end

%				patch('faces',elem, ...
%					'vertices',[X Y Z], ...
%					'FaceVertexCData',val,  ...
%					'FaceColor','flat', ...
%					'edgecolor','none')
if (~opt.scatter)
	
%		for idx=1:1
%				elem_ = elem;
%				elem_(:,5) = elem_(:,1);
%		jd = 1:10;
		face = [];
		for idx=1:4
		face_ = elem;
		face_(:,idx) = [];
		face = [face,face_];
		end
%		for jdx=1:5
%			elem_ = elem(jd,:);
%			elem__ = elem_(jdx:5:end,:);
%			size(X)
%			elem__
%			X(elem__)
%			Y(elem__)
%			Z(elem__)
%			pause
%			o = jdx*ones(size(elem__,1),1)/5;
				patch(  'faces',face, ...
					'vertices',[X Y Z], ...
					'FaceVertexCData',val,  ...
			...		'FaceVertexCData', o, ... % 'FaceColor',cvec(jd)/max(jd)*[1 1 1], ...
					'FaceColor','interp', ...
					'edgecolor','none' ...
					);
					%, ...
					%'FaceAlpha',0.5)
				hold on
%		end % for jdx
%		end % for idx
else
	%plot3(X,Y,Z,'.')
	scatter3(X,Y,Z,[],val,'.')
end
%		end
%	elem(1,:)
%	size(elem)
%	size(X(elem))
%	V = Geometry.tetra_volume(X(elem),Y(elem),Z(elem));
%	V(1:10)
%	size(V)
%else
%	plot(sort(V))
%end
	
	
end

