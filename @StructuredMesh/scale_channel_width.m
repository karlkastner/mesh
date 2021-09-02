function obj = scale_channel_width(obj,p)
	X = obj.X;
	Y = obj.Y;
	for idx=1:2
	X0 = mean(X,idx);
	Y0 = mean(Y,idx);

	X = X0 + p(idx)*(X-X0);
	Y = Y0 + p(idx)*(Y-Y0);
	end
	obj.X = X;
	obj.Y = Y;
end


