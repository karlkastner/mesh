% Tue 19 Feb 11:49:15 CET 2019
%% quiver plot of velocity
function quiver(obj,u,v,varargin)
	n = obj.n;
	nu = size(u);
	if (nu(1) == n(1) && nu(2) == n(2))
		quiver(obj.X,obj.Y,u,v,varargin{:});
	elseif(numel(u) == prod(n))
		quiver(flat(obj.X),flat(obj.Y),u,v,varargin{:});
	elseif (nu(1) == n(1)-1 && nu(2) == n(2)-1)
		dmesh = obj.dual_mesh();
		dmesh.quiver(u,v,varargin{:});
	else
		error('here');
	end
end
