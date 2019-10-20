% Mi 30. Sep 14:18:34 CEST 2015
% Karl Kastner, Berlin
%% check boundary conditions for stacked domains
function [isinvalid, obj] = bc_isinvalid(obj,BC)
	field_C = { 'north', 'east', 'south', 'west' };
	isinvalid = false;
	% TODO check completeness of BC
	for idx=1:length(BC)
		bc = BC(idx);
		for jdx=1:length(field_C)
		side = field_C{jdx};
		if (~isfield(bc,side))
			warning(sprintf('Block %d misses %s side\n',side));
			isinvalid = true;
		end % if side does not exist
		end % for jdx (each side)

		% todo check x, y

		% check that opposing side have equal number of elements
		if (bc.north.n ~= bc.south.n)
			error(sprintf('Block %d has and unequal number of elements on north and south side',idx));
		end
		if (bc.east.n ~= bc.west.n)
			error(sprintf('Block %d has and unequal number of elements on east and west side',idx));
		end

	end % for idx (each block)
end % function bc_isinvalid

