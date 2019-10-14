% Thu 22 Nov 13:54:11 CET 2018
function [bnd,iscorner] = boundary_chain(obj)
	valid = isfinite(obj.X);
	invalid = true(obj.n+2);
	invalid(2:end-1,2:end-1) = ~valid; 
	ni =   1*invalid(1:end-2,2:end-1) ... % top
	     + 2*invalid(2:end-1,  3:end) ...   % right
	     + 4*invalid(  3:end,2:end-1) ...   % bottom
	     + 8*invalid(2:end-1,1:end-2);    % left
	ni = flat(ni);
	nn = length(ni);
	n = obj.n;
	bnd = [];
	iscorner=false(0);
	for id=1:nn
	if (valid(id))
	switch (ni(id))
	case {0} % domain interior, no boundary
	case {1} % top side only, put left right
		bnd(end+1,:) = [id,id-n(1),id+n(1)];
		iscorner(end+1,1) = false;
	case {2} % right only, put top bottom
		bnd(end+1,:) = [id,id-1,id+1];
		iscorner(end+1,1) = false;
	case {4} % bottom only, put left right
		bnd(end+1,:) = [id,id-n(1),id+n(1)];
		iscorner(end+1,1) = false;
	case {8} % left only, put top and bootom
		bnd(end+1,:) = [id,id-1,id+1];
		iscorner(end+1,1) = false;
	case {3} % corner, top and right, put left and bottom
		bnd(end+1,:) = [id,id-n(1),id+1];
		iscorner(end+1,1) = true;
	case {6} % right and bottom, put top and left
		bnd(end+1,:) = [id,id-1,id-n(1)];
		iscorner(end+1,1) = true;
	case {12} % bottom and left, put top and right
		bnd(end+1,:) = [id, id-1, id+n(1)];
		iscorner(end+1,1) = true;
	case {9} % left and top, put bottom and right
		bnd(end+1,:) = [id, id+1, id+n(1)];
		iscorner(end+1,1) = true;
	otherwise
		id
		ni(id)
		error('here');
	end % switch
	end % if valid(id)
	end % for id
end % boundary_chain

