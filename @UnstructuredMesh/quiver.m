% Wed 20 May 16:52:49 +08 2020
function quiver(obj,u,v,varargin)
	switch (numel(u))
	case {obj.np}
		quiver(obj.X,obj.Y,flat(u),flat(v),varargin{:});
	case {obj.nelem}
		XY = obj.element_midpoint();	
		quiver(XY(:,1),XY(:,2),flat(u),flat(v),varargin{:});
	otherwise
		error('here');
	end
end
