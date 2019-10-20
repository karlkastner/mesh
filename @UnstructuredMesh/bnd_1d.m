% Wed 30 Nov 19:22:23 CET 2016
%% left and right end points for 1D meshes
function [elembnd, obj] = bnd_1d(obj)
	[elem2, fdx] = obj.elemN(2);
	if (~isempty(elem2))
		[u, n] = count_occurence(elem2(:));
		pdx = u(n==1);
		fdx = false(obj.np,1);
		fdx(pdx) = true;
		edx = fdx(elem2(:,1));
		elembnd = elem2(edx,:);
		edx = fdx(elem2(:,2));
		elembnd = [elembnd;
                           [elem2(edx,2), elem2(edx,1)]];
	else
		elembnd = [];
	end
end % bnd_1d

