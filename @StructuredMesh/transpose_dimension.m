% Sat 19 Oct 18:41:51 PST 2019
% Karl Kastner, Berlin
%% transpose dimensions
function obj = transpose_dimension(obj,dim)
	obj.X = obj.X.';
	obj.Y = obj.Y.';
end
