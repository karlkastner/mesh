% Sa 14. Nov 16:21:22 CET 2015
% Karl Kastner, Berlin
%
%% crop mesh to polygonal region
%
function cut(obj,Xb,Yb)
	X = obj.point(:,1);
	Y = obj.point(:,2);
	in = inpolygon(vx,vy,X0,Y0);
	% find points outside the domain
	fdx = find(~in);
	% determine elements with points outside the domain
	
	% remove elements where all points are outside of the domain
	% TODO, this is not necessarily true

	% remove the points that are outside of the domain

	ne = size(elem,1);
	delem = false(ne,1);

	% for each element
	for idx=1:ne
		% test if it intersects the boundary
		[xi,yi,ii] = polyxpoly(X(elem(idx,:)),Y(elem(idx,:)),Xb,Yb);
		switch (length(xi))
		case {0} % no intersection
			if (0 == nin)
				% all points outside, mark element for deletion
				delem(idx) = true;
			else
				% this is an internal element, do nothing
			end
		case {1} % touches boundary
			if (1 == nin)
				% this element only touches the domain, mark for deletion
				delem(idx) = true;
			end
		case {2} % intersects boundary
			% if it intersects more than 2 times, error
			% break element apart by adding the connecting points and removing the points outside the domain
			% TODO, this is not good if the boundary contains a corner
			
		otherwise
			error('multi-intersection is not implemented');
	end
		
	end % for idx
	% join points that are ident
	% remove elements
	elem = elem(~delem,:);
	obj.elem = elem;
end % function cut
	
