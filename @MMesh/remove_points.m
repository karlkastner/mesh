% Sa 28. Nov 11:00:29 CET 2015
% Karl Kastner, Berlin
%
% remove points and associated elements
%
% TODO do this with edges as well
%
% QUADSAVE_TRUE
function [ddx obj] = remove_points(obj, dpoint)
	if (islogical(dpoint))
		dpoint = find(dpoint);
	else
		% paranoid
		dpoint = unique(dpoint);
	end
	np = obj.np;
	% number of points after removal
	np_ = obj.np - length(dpoint);
	% mark points for removal
	pdx         = ones(np,1);
	pdx(dpoint) = 0;
	% new point index
	pdx         = cumsum(pdx);
	pdx(dpoint) = 0;
	% remove points
	obj.point(dpoint,:) = [];

	field_C = fieldnames(obj.pval);
	for idx=1:length(field_C)
		obj.pval.(field_C{idx})(dpoint) = [];
	end

	% reassign the new point indices
	fdx  = (obj.elem > 0);
	obj.elem(fdx) = pdx(obj.elem(fdx));

	% remove elements that reference to removed points
	% fdx makes sure, that this also works for mixtures of triangles and quadrilaterals
	fdx = any((0==obj.elem) & fdx,2);
	obj.elem(fdx,:) = [];

	% index of points that stay
	ddx         = true(np,1);
	ddx(dpoint) = false;
end % remove_points

