% Fri  5 Aug 14:03:16 CEST 2016
function [id, S, id0, obj] = path(obj,arg)
	A = obj.vertex_distance();

	if (isinteger(arg))
		id0 = arg;
	else
		xy0 = arg;

		% search closest mesh points
		id0 = knnsearch(obj.point(:,1:2),xy0(:,1:2));
	end

	% search shortest connection
	[~, id] = graphshortestpath(A,id0(1),id0(2));
	id  = cvec(id);
	idA = sub2ind(size(A),id(1:end-1),id(2:end));

	% distance along path
	if (nargout() > 1)
		dS  = full(A(idA));
		S   = [0;cumsum(dS)]; 
	end
end % path

