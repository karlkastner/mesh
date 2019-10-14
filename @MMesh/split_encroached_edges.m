% Wed 26 Oct 09:54:18 CEST 2016
% Karl Kastner, Berlin
function obj = split_encroached_edges(obj,iterative)
	if (nargin() < 2)
		iterative = false;
	end
	while (1)
		edx = obj.find_encroached_edges();

	if (1)
		o = obj.isobtuse();
		figure()
		opt.edges=true;
		obj.plot(o,opt);
		Pc = obj.edge_midpoint(edx);
		hold on
		plot(Pc(:,1),Pc(:,2),'g.');
		axis equal
		drawnow
	end
		printf('Spliting %d encroached edges\n',length(edx));
		if (isempty(edx))
			break;
		end
		obj.split_edge(edx);
%		obj.smooth2(100);
		if (~iterative)
			break;
		end
	end % while 1
end % split_encroached_edges

