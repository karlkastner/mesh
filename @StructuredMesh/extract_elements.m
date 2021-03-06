% Do 1. Okt 12:15:19 CEST 2015
% Karl Kastner, Berlin
%
%% element indices from grid
% converts a structured grid into a mesh
function obj = extract_elements(obj,invalid_)
	if (nargin()<2)
		% TODO this does not work for NaN, then isvalid function has to be used
		invalid_ = NaN;
	end
	%M = struct();
	% point coordinates
	X = obj.X;
	Y = obj.Y;

	n1 = size(X,1);
	n2 = size(X,2);
	elem = zeros((n1-1)*(n2-1),4);
%	E = zeros((n1-1)*(n2-1),4);
%	C = zeros((n1-1)*(n2-1),4);
	n = 0;
	% elements
	for idx=1:n1-1
	 for jdx=1:n2-1
		% check that none of the elements is invalid
		if (   X(idx,jdx)   ~= invalid_ && X(idx+1,jdx)   ~= invalid_ ...
		    && X(idx,jdx+1) ~= invalid_ && X(idx+1,jdx+1) ~= invalid_ ...
		    && Y(idx,jdx)   ~= invalid_ && Y(idx+1,jdx)   ~= invalid_ ...
		    && Y(idx,jdx+1) ~= invalid_ && Y(idx+1,jdx+1) ~= invalid_)
			% push back an element
			n = n+1;
			elem(n,:) = sub2ind([n1,n2],[idx idx+1 idx+1 idx],[jdx jdx   jdx+1 jdx+1]);
%			E(n,:) = [idx idx+1 idx idx+1]
%			C(n,:) = [jdx jdx   jdx+1 jdx+1];
		end
	 end % for jdx
	end % for idx
%	E = E(1:n,:);
%	C = C(1:n,:);
%	M.elem.E = E;
%	M.elem.C = C;
	elem = elem(1:n,:);
	obj.elem = elem;
end % grid2mesh

