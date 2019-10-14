% Wed  9 Nov 11:18:59 CET 2016
% Karl Kastner, Berlin
% input
%	tdx(:,1) and tdx(:,2) pairs of triangles facing each other (not necessary)
%
function [facing shared obj] = get_facing_and_shared_vertices(obj,tdx)
	n  = size(tdx,1);

	% allocate memory
	facing = zeros(n,2);
	shared = zeros(n,2);

	% exclude zero indices
	fdx = all(tdx > 0,2);
	
	% vertex indices of triangles
	e1 = obj.elem(tdx(fdx,1),:);
	e2 = obj.elem(tdx(fdx,2),:);
	
	% masks for shared vertices
	iflag = false(sum(fdx),3);
	jflag = false(sum(fdx),3);
	for idx=1:3
		for jdx=1:3
			flag         = (e1(:,idx) == e2(:,jdx));
			iflag(:,idx) = iflag(:,idx) | flag;
			jflag(:,jdx) = jflag(:,jdx) | flag;
		end % for jdx
	end % for idx

	% facing vertices are those vertices that are not shared
	facing(fdx,1) = sum(e1.*(~iflag),2);
	facing(fdx,2) = sum(e2.*(~jflag),2);
	cs            = cumsum(iflag,2);
	shared(fdx,1) = sum(e1.*(cs==1).*iflag,2);
	shared(fdx,2) = sum(e1.*(cs==2).*iflag,2);
end % function

