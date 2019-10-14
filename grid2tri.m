% Fri  1 Jun 10:43:26 CEST 2018
function [elem] = grid2tri(n)
	id1 =  (1:n(1))';
	id2 = (0:n(2)-1)*n(1);
	id = bsxfun(@plus,id1,id2);
	elem = [ flat(id(1:end-1,1:end-1)), flat(id(1:end-1,2:end)), ...
	         flat(id(2:end,2:end)); ...
	         flat(id(2:end,2:end)), flat(id(2:end,1:end-1)), ...
	         flat(id(1:end-1,1:end-1))];
end
