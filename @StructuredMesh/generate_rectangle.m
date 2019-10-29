% Thu 10 May 18:05:02 CEST 2018
%% discretize a rectangular domain
% function obj = generate_rectangle(obj,X,Y,n)
function obj = generate_rectangle(obj,X,Y,n)
	X = linspace(X(1),X(2),n(1));
	Y = linspace(Y(1),Y(2),n(2));
	obj.X = X.'*ones(1,n(2));
	obj.Y = ones(n(1),1)*Y;
	obj.extract_elements(NaN);
end

