% Mon 14 Dec 16:00:11 +08 2020
function obj = refine(obj)
	n  = obj.n;
	ii = 1:0.5:n(1);
	ji = 1:0.5:n(2);
	i  = 1:n(1);
	j = 1:n(2);

	X = interp1(i,obj.X,ii,'spline');
	X = interp1(j',X',ji,'spline')';
	Y = interp1(i,obj.Y,ii,'spline');
	Y = interp1(j',Y',ji,'spline')';
	
	obj.X = X;
	obj.Y = Y;
	obj.S_ = [];
	obj.N_ = [];
	obj.extract_elements();
end
