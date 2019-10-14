% Wed 23 May 20:08:15 CEST 2018
function obj = flip_dimension(obj,dim)
	if (dim(1))
		obj.X = flipud(obj.X);
		obj.Y = flipud(obj.Y);
	end
	if (dim(2))
		obj.X = fliplr(obj.X);
		obj.Y = fliplr(obj.Y);
	end
end
