% 2015-11-11 12:12:02.560441604 +0100
% Karl Kastner, Berlin

%- for each ill conditioned triangle
%	- optimise dx,dy for each corner point
%	  such that orthogonality is improved
%	  and neighbours stay orthogonal
%	- get gradient of the objective function for each of the three corner points
%	- optimise along gradiend step with linesearch algorithm
%	- project, such that neighours stay orthogonal

