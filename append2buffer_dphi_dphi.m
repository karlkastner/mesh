% Thu 14 May 11:52:10 +08 2020
function [buf,nb] = append2buffer_dphi_dphi(buf,nb,T,wfa,ux,uy)
	nt2 = length(T);
	% mass matrix contributions
	% for all test functions being 1 at point adx
	for adx=1:nt2
		% diagonal entry integral approximation
		% factor 0.5 for later symmetry completion
		I         = 0.5*sum( wfa.*(ux(:,adx).^2 ...
                                         + uy(:,adx).^2) );
		nb        = nb+1;
		buf(nb,1) = T(adx);
		buf(nb,2) = T(adx);
		% separate, as otherwise silent conversion to int 
		buf(nb,3) = I;
		% off-diagonal entries
		% exploit symmetry A(i,j) = A(j,i)
		for bdx=(adx+1):nt2
			% integral approximation
			I = sum( wfa.*(  ux(:,adx).*ux(:,bdx) ...
				       + uy(:,adx).*uy(:,bdx)) );
			nb = nb+1;
			buf(nb,1) = T(adx);
			buf(nb,2) = T(bdx);
			% separate, as otherwise silent conversion to int 
			buf(nb,3) = I; 
		end % for jdx
	end
end

