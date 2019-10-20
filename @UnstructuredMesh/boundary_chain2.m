% Thu 16 Jun 17:10:13 CEST 2016
% Karl Kastner, Berlin
%% get chained indices of boundary segments,
%% used for setting up higher order polynomials along the boundary
%  TODO this function is inefficient, can be improved by tree or hash
function [bnde_C, bnd_C, obj] = boundary_chain2(obj)
	bnd    = obj.bnd;
	bnde   = obj.edge(bnd,:);
	bnd_C = {};
	bnde_C = {};
	nbnd  = length(bnd);
	% as long as there are unprocessed elements
	while (nbnd > 0)
		% last unprocessed edge
		chaine = bnde(nbnd,:);
		chain  = bnd(nbnd);
		nbnd   = nbnd-1;
		% while chain is not yet a circle
		while (chaine(1) ~= chaine(end))
			% find right neigbour
			fdx = find(chaine(end) == bnde(1:nbnd,1),1,'first');
			if (~isempty(fdx))
				chaine(end+1) = bnde(fdx,2);
				chain(end+1)  = bnd(fdx);
				% pop element
				bnde(fdx,:)   = bnde(nbnd,:);
				bnd(fdx)      = bnd(nbnd);
				nbnd  = nbnd-1;
				continue;
			end
			fdx = find(chaine(end) == bnde(1:nbnd,2),1,'first');
			if (~isempty(fdx))
				chaine(end+1) = bnde(fdx,1);
				chain(end+1)  = bnd(fdx);
				% pop element
				bnde(fdx,:) = bnde(nbnd,:);
				bnd(fdx)      = bnd(nbnd);
				nbnd  = nbnd-1;
				continue;
			end
			error('here');
		end % while chain is not complete
		% push chain
		bnde_C{end+1} = chaine;
		bnd_C{end+1}  = chain;
	end % while nbnd > 0
end % boundary_chain2

