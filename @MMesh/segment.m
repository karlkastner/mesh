% 2016-01-26 20:01:39.669533928 +0100
% Mi 27. Jan 11:54:22 CET 2016
%
% segment the mesh into parts according to laplacian eigenvalues
%
% TODO, terminate if mesh has less than two elements
% TODO, split boundaries
% TODO, this works so far only for triangles
% decompose the domain in smaller sized segments
function [mesh_A obj] = segment(obj, level, id);
	if (nargin() < 3)
		id = (1:obj.np)';
	end
	% end of recursion
	if (level <= 0)
		obj.l2g         = id;
		mesh_A          = Mesh_Array(obj);
		mesh_A.tsdx     = ones(obj.nelem,1);
		mesh_A.tdx_g2l  = (1:obj.nelem)';
		%mesh_A.pdx_l2g = {id};
		%(1:obj.np)};
	else
	% fetch
	elem3 = obj.elemN(3);

	% get the first two principle eigenvectors of the laplacian with neuman conditions
	V = obj.eigs(2,'neumann');

	% split point set in two according to the second eigenvector
	fdx = V(:,2) > 0;

	% split element in set in two
	tdx1   = sum(fdx(elem3),2) > 1;
	tdx2   = ~tdx1;

	% first set
	pdx1   = false(obj.np,1);
	pdx1(elem3(tdx1,:)) = true;
	mesh1 = MMesh(obj.point(pdx1,:),elem3(tdx1,:));
	% renumber the point indices
	jd1 = mesh1.renumber_point_indices();

	% second set
	pdx2  = false(obj.np,1);
	pdx2(elem3(tdx2,:)) = true;
	mesh2 = MMesh(obj.point(pdx2,:),elem3(tdx2,:));
	% renumber the point indices
	jd2 = mesh2.renumber_point_indices();

	% segment index	
	tsdx        = ones(obj.nelem,1);
	tsdx(tdx2)  = 2^(level-1)+1;
	tdx_g       = zeros(obj.nelem,1);

	% recursive splitting
	mA1         = mesh1.segment(level-1,id(pdx1));
	tsdx(tdx1)  = tsdx(tdx1) + mA1.tsdx - 1;
	% global to local index
	tdx_g(tdx1) = mA1.tdx_g2l;

	mA2         = mesh2.segment(level-1,id(pdx2));
	tsdx(tdx2)  = tsdx(tdx2) + mA2.tsdx - 1;
	tdx_g(tdx2) = mA2.tdx_g2l;

	mesh_A         = Mesh_Array(mA1, mA2);
	mesh_A.tsdx    = tsdx;
	mesh_A.tdx_g2l = tdx_g;
	%else
	%	% global to local index
	%	tdx_g     = zeros(mesh.nelem,1);
	%	tdx_g(tdx1) = (1:sum(tdx1));
	%	tdx_g(tdx2) = (1:sum(tdx2));
	end % else of if level <= 0
end % segment

