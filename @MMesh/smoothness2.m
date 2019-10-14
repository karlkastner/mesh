% 2015-11-24 13:54:39.312150765 +0100

%- simpler for triangles: only consider own points -> does not work, 4 points necessry for second derivative
%	- take egdge centres and centre of circumference
%- 
%
%	for each element
%	- get centre of cicumference
%	- get dx to neighbours
%       (x_i-1 - 2 x_i + dx_i+1)/(1/2(dx_i+1 - dx_i-1))^2 < 1$$
%	- linf norm
%	s = (max(dx)-min(dx))/min(dx)
