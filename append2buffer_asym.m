% Thu 14 May 13:06:59 +08 2020
function [buf, nb] = append2buffer_asym(buf,nb,T,wfa,u,v)
	nt2 = length(T);
	% mass matrix contributions
	% for all test functions being 1 at point adx
	for adx=1:nt2
		for bdx=1:nt2
			% integral approximation
			I = sum( wfa.*(  u(:,adx).*v(:,bdx) ));
			nb = nb+1;
			buf(nb,1) = T(adx);
			buf(nb,2) = T(bdx);
			% separate index from value
			% as otherwise value might silently converted to int 
			buf(nb,3) = I; 
		end % for bdx
	end % for adx
end
