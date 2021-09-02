% Tue  6 Apr 20:55:34 CEST 2021
function plot_vtk(m,field)
	if (ischar(m))
		m = read_vtk(m);
	end
	c = m.cells;
	x = m.points(:,1);
	y=m.points(:,2);
%	c(:,end+1) = c(:,1);
	z=m.points(:,3);
	c=c';
	patch(x(c),y(c),z(c),m.cell_data.(field),'edgecolor','none');
%colorbar; limits(flat(m.cell_data.(f)))
end

