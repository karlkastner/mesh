% Mon 18 May 20:40:57 +08 2020
classdef Mesh < handle
	properties
		% boundary condition information
		boundary_condition_s = struct();
	end
	properties (Access = protected)
		% derivative matrices
		D = struct(  'x',  [] ...
                           , 'y',  [] ...
			   , 'xx', [] ...
			   , 'xy', [] ...
			   , 'yy', [] ...
			   ,  'L', [] ...
			  );
	end
	methods
		function Dx = Dx(obj)
			if (isempty(obj.D.x))
				obj.derivative_matrices();
			end
			Dx = obj.D.x;
		end
		function Dy = Dy(obj)
			if (isempty(obj.D.y))
				obj.derivative_matrices();
			end
			Dy = obj.D.y;
		end
		function D2x = D2x(obj)
			if (isempty(obj.D.xx))
				obj.derivative_matrices();
			end
			D2x = obj.D.xx;
		end
		function Dxy = Dxy(obj)
			if (isempty(obj.D.xy))
				obj.derivative_matrices();
			end
			Dxy = obj.D.xy;
		end
		function D2y = D2y(obj)
			if (isempty(obj.D.yy))
				obj.derivative_matrices();
			end
			D2y = obj.D.yy;
		end
		function L = L(obj)
			if (isempty(obj.D.L))
				obj.derivative_matrices();
			end
			L = obj.D.L;
		end
	end
end

