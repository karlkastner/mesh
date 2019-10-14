% Thu Jul  3 17:57:20 WIB 2014
% Karl Kastner, Berlin
%
%% matrix for gauss integration on a triangulation
% TODO move to mesh
function [A, W] = gaussmat_2d(mesh,ifunc)
	gdx = 0;
	na  = 0;
	[w, b] = feval(ifunc);
	abuf  = zeros(size(mesh.T,1)*length(w),3);
	W     = zeros(size(mesh.T,1)*length(w),1);
	for tdx=1:size(mesh.T,1)
		% get Gauss points in barycentric coordinates
		% This is analogue to solve A_g A_t^-1
		for adx=1:length(w)
		gdx = gdx+1;
		W(gdx,1) = w(adx);
		for bdx=1:3
			na=na+1;
			abuf(na,1) = gdx;
			abuf(na,2) = mesh.T(tdx,bdx);
			abuf(na,3) = b(adx,bdx);
		end
		end
	end
	A = sparse(abuf(:,1),abuf(:,2),abuf(:,3));
	W = spdiags(W,0,length(W),length(W));
end % gaussmat_2d

