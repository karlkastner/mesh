% Fri 18 Nov 14:59:43 CET 2016
% Karl Kastner, Berlin
%
%% generate a uniform 2D mesh
%
function obj = generate_uniform_grid(obj, n,L,x0)
	if (nargin() < 2)
		L = [1 1];
	end
	if (nargin() < 3)
		x0 = [0 0];
	end

	x = (0:n(1)-1)*L(1)/(n(1)-1)  + x0(1);
	y = (0:n(2)-1)'*L(2)/(n(2)-1) + x0(2);
	x = repmat(x,n(2),1);
	y = repmat(y,1,n(1));
	x = x';	
	y = y';	
	obj.point = [x(:) y(:)];	

	elem = [];
	for idx=1:n(2)-1
		%ne = length(elem);
		elem = [elem; n(1)*(idx-1)+[(1:(n(1)-1))' (2:n(1))' n(1)+(2:(n(1)))' n(1)+(1:n(1)-1)']];
	end
	obj.elem = elem;
	obj.edges_from_elements();
end

