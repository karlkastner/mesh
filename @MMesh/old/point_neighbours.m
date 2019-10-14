% Sa 13. Feb 23:29:16 CET 2016
% Karl Kastner, Berlin
%
% connectivity matrix for all points 
%
function [ptp_C obj] = point_neighbours(obj)
	warning('point neighbours has been replaced by vertex_connectivity');
	ptp_C = cell(obj.np,1);
	l     = [3 1 2];
	r     = [2 3 1];
	for idx=1:obj.nelem
		for jdx=1:3
			ptp_C{obj.elem(idx,jdx)}(end+1:end+2) = ...
				[ obj.elem(idx,l(jdx)), obj.elem(idx,r(jdx)) ];
		end
	end
	ptp_C = cellfun(@unique,ptp_C,'uniformOutput',false);
end

