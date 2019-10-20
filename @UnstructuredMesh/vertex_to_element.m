% Do 28. Jan 09:16:22 CET 2016
% Karl Kastner, Berlin
%
%% connectivity matrix between vertices and elements
%
% TODO only implemented for triangles
%
% element to point indicator matrix (sparse)
% rows    : vertices
% columns : elements
function [A obj] = vertex_to_element(obj)
	buf1 = [];
	buf2 = [];

	for idx=2:size(obj.elem,2);

		% fetch elements
		[elem id] = obj.elemN(idx);

		% vertex indices
		buf1 = [buf1; elem(:)];
	
		% element indices
		buf2 = [buf2; repmat(id,idx,1)];		
	end
	% adjacency matrix
	A   = sparse(double(buf1),double(buf2),ones(length(buf1),1),obj.np,obj.nelem);
end

%function [pt el Ap2e obj] = point_to_elem(obj)
%	elem3 = obj.elemN(3);
%	ne    = size(elem3,1);
%	np    = obj.np;
%	el    = reshape(repmat((1:ne)',1,3),[],1);
%	pt    = double(reshape(elem3,[],1));
%	buf3  = ones(3*ne,1);
%	if (nargout() > 2)
%		Ap2e = sparse(pt,el,buf3,np,ne);
%	end
%end

