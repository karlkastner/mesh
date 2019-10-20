% Mi 30. Sep 09:44:10 CEST 2015
% Karl Kastner, Berlin
%
%% stack multiple meshes to complex domain
%
% arg  1 2 3 4  5 6 7 8
%      sides    connection
%      n e s w  n e s w
%
% create square blocks in boundary condition format
function B = block(arg,nx,ny)
	% for each block
	for idx=1:size(arg,1)
		B(idx).north.X    = linspace(arg(idx,4),arg(idx,2),nx)';
		B(idx).east.X     = arg(idx,2)*ones(ny,1);
		B(idx).south.X    = B(idx).north.X;
		B(idx).west.X     = arg(idx,4)*ones(ny,1);

		B(idx).north.Y    = arg(idx,1)*ones(nx,1);
		B(idx).east.Y     = linspace(arg(idx,3),arg(idx,1),ny)';
		B(idx).south.Y    = arg(idx,3)*ones(nx,1);
		B(idx).west.Y     = B(idx).east.Y;

		B(idx).north_link = arg(idx,5);
		B(idx).east_link  = arg(idx,6);
		B(idx).south_link = arg(idx,7);
		B(idx).west_link  = arg(idx,8);
	end % for each block

%	B = bc_index(B);
end % function block

