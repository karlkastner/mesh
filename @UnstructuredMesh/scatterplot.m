% Mon  6 Feb 10:21:24 CET 2017
%% scatterplot of data on mesh
% TODO allow scatterplot for element midpoints
function obj = scatterplot(obj,val)
	if (nargin()<2)
		val = obj.Z;
	end
	scatter3(obj.X,obj.Y,val,[],val);
	view(0,90) 
end

