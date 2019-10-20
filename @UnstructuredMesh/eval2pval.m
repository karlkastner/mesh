% Fri 16 Jun 10:50:27 CEST 2017
%% element (centroid) value to vertex value
%% TODO, use dual mesh or triangulation
function [valp,obj] = eval2pval(obj,vale)
	if (isvector(vale))
		valp = cvec(vale);
	end
	valp = zeros(obj.np,1);
	n    = zeros(obj.np,1);

	for idx=2:size(obj.elem,2)
		[elem fdx] = obj.elemN(idx);
		for jdx=1:idx
			for kdx = 1:size(elem,1)
				valp(elem(kdx,jdx)) = valp(elem(kdx,jdx)) + vale(fdx(kdx));
				n(elem(kdx,jdx)) = n(elem(kdx,jdx)) + 1;
			end
	%		valp(elem(:,jdx)) = valp(elem(:,jdx)) + vale(fdx);
		end
	end
	valp = valp./n;
end
