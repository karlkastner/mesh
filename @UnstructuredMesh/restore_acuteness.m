% Sat 11 Jun 13:48:53 CEST 2016
% Karl Kastner, Berlin
%% restore acuteness
%% Laplacian smoothing may at some places decrease the mesh quality,
%% this locally restores acute elements
function XY = restore_acuteness(elem,XY,XY0,verbose)
	if (nargin() < 3 || isempty(verbose))
		verbose = false;
	end
	% determine acute triangles of original mesh
	a0 = Geometry.isacute(reshape(XY0(elem,1),[],3),...
			      reshape(XY0(elem,2),[],3));
	while (1)
		% determine acute triangles
	%	a = Geometry.isacute(XY(elem,1),XY(elem,2));
	a = Geometry.isacute(reshape(XY(elem,1),[],3),...
			      reshape(XY(elem,2),[],3));
		% determine triangles that were acute but became obtuse
		msk = find(a0 & ~a);
		if (isempty(msk))
			break;
		end
		if (verbose)
			fprintf(1,'Restoring %d elements\n',length(msk));
		end
		% restore coordiantes
		XY(elem(msk,:),1) = XY0(elem(msk,:),1);
		XY(elem(msk,:),2) = XY0(elem(msk,:),2);
	end % while (1)
end % restore_acuteness

