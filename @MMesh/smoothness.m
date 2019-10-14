% 2015-11-03 10:40:45.504863622 +0100
%
% mesh smoothness as ratio of maximum edge length and minimum edge length
%
function [sT, sE, obj] = smoothness(obj)
	L = obj.edge_length();

	% fetch
	X = obj.elemX();
	Y = obj.elemY();
	
	elem2edge = obj.elem2edge();
	d   = L(elem2edge);
	[max_d max_dx]  = max(d,[],2);
	[min_d min_dx]  = min(d,[],2);
	
	sT = max_d./min_d;

	% maximum ratio per edge
	s = bsxfun(@times,d,1./min_d);

	% mark maximum edges
	sE = accumarray(elem2edge(:),s(:),[obj.nedge,1],@max);
end

