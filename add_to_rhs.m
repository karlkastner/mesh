% Thu 14 May 13:06:59 +08 2020
% add to right hand side L, the linear operator
function [rhs] = add_to_rhs(rhs,T,wfa,v,du_dn)
	nt2 = length(T);
	% mass matrix contributions
	% for all test functions being 1 at point adx
	for adx=1:nt2
		% integral approximation
		I = sum( wfa.*(  v(:,adx).*du_dn ));
		rhs(T(adx)) = rhs(T(adx)) + I;
%		nb = nb+1;
%		buf(nb,1) = T(adx);
%		buf(nb,2) = T(bdx);
		% separate index from value
		% as otherwise value might silently converted to int 
%		buf(nb,3) = I; 
	end % for adx
end
