% Mi 30. Sep 10:01:51 CEST 2015
% Karl Kastner, Berlin
%% TODO this is deprecated
%% generate indices for boundary edges
function [BC, obj] = bc_index(obj,BC)
	% generate cdx and edx
	for idx=1:length(BC)
		% TODO check for consistency
		nc = length(BC(idx).north.X);
		nr = length(BC(idx).east.X);

		BC(idx).north.edx   = (1:nc)';
		BC(idx).north.cdx   = (nr-1)*ones(nc,1);
		BC(idx).east.edx  = nc*ones(nr,1);
		BC(idx).east.cdx  = (0:nr-1)';
		BC(idx).south.edx = (1:nc)';
		BC(idx).south.cdx = 0*ones(nc,1);
		BC(idx).west.edx  = ones(nr,1);
		BC(idx).west.cdx  = (0:nr-1)';
		
	end % for each block
end % bc_index

