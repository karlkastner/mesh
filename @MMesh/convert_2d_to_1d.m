% Wed 30 Aug 16:36:41 CEST 2017
%
function obj = convert_1d_to_2d(obj)
	% 1) identify 2d elements with two facing bountary edges
	%    TODO, extend to triangles
	% 2) compute width
	% 3) collapse the two points of the two non boundary edges into 1 point
	% find junction elements (elements connected to 3 1d elements)
	% replace junction element by 3 1d edges
end

