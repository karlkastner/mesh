% Sat 19 May 12:31:34 CEST 2018
%% plot the mesh boundary
% TODO mark depending on boundary condition
function plot_boundary(obj,varargin)
	[bnd,iscorner] = obj.boundary_chain();

	X = obj.X;
	Y = obj.Y;
	plot([X(bnd(:,[2,1,3])),NaN(size(bnd,1),1)]',[Y(bnd(:,[2,1,3])),NaN(size(bnd,1),1)]','k','linewidth',1.5,varargin{:});
	
	hold on
	plot(X,Y,'b.')
	plot(X(bnd(:,1)),Y(bnd(:,1)),'r.')

end % plot_boundary

