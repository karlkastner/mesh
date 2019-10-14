% 2015-10-31 14:59:19.704138840 +0100
%
% concatenate two meshes
%
function obj = cat(obj,obj2,dmerge)
	np1        = obj.np;
	np2        = obj2.np;
	ne1 = obj.nelem;
	ne2 = obj2.nelem;

	obj.point = [obj.point; obj2.point];
	obj.elem(ne1+(1:ne2),1:size(obj2.elem,2))  = obj2.elem + np1;

	field_C = fieldnames(obj2.pval);
	for idx=1:length(field_C)
		if (~isfield(obj.pval,field_C{idx}))
			obj.pval.(field_C{idx}) = NaN(np1,1);
		end
		obj.pval.(field_C{idx})(np1+1:np1+np2) = obj2.pval.(field_C{idx});
	end

	field_C = fieldnames(obj.pval);
	for idx=1:length(field_C)
		if (~isfield(obj2.pval,field_C{idx}))
			obj.pval.(field_C{idx})(np1+1:np1+np2) = NaN;
		end
	end

	% merge point
	if (nargin() > 2)
		obj.merge_duplicate_points(dmerge);
	end

	mesh.edges_from_elements();
end % cat

