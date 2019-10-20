% 2016-09-28 19:36:28.085981704 +0800
% number of edges
function nedge = nedge_(obj,nelem,nbnd)
	if (nargin() < 2)
		nelem = obj.nelem;
		nbnd = obj.nbnd;
	end
	% each triangle has three edges
	% each edge is shared by two triangles except boundary edges
	nedge = (3*nelem+nbnd)/2;
end
	
