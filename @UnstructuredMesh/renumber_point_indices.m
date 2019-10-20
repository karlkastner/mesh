% Mi 27. Jan 12:12:25 CET 2016
% Karl Kastner, Berlin
%
%% renumber vertex indices
%
% TODO, this is so far only implemented for triangles
% TODO boundary correct boundary and edge indices
function [jd obj] = renumber_point_indices(obj)
	% correct indices
	[s id jd]  = unique(obj.elem);
	vec = (1:length(s))';
	obj.elem = reshape(vec(jd),[],3);
end

