% Wed 21 Feb 18:04:07 CET 2018
%% generate a mesh from a given centreline
%% TODO : avoid crossing of inner bed points in sharp bends
% function [obj] = generate_from_centreline(obj,X0,Y0,W0,dS,nn)
function [obj] = generate_from_centreline(obj,X0,Y0,W0,dS,nn)
		imethod = 'pchip';
		X0 = cvec(X0);
		Y0 = cvec(Y0);
	
		S0 = cvec(Geometry.arclength(X0,Y0));
		
		ns = max(1,round(S0(end)/dS))+1;
		
		S = (0:ns-1)'*S0(end)/(ns-1);

		if (~isscalar(W0))
			W = interp1(S0,W0,S,imethod)
		else
			W = repmat(W0,ns,1);
		end
		S = repmat(S,1,nn);
		N = bsxfun(@times,cvec(W),(0:nn-1)/(nn-1)-1/2);

		[X,Y] = sn2xy(X0,Y0,S0,flat(S),flat(N));

		obj.X    = reshape(X,[],nn);
		obj.Y    = reshape(Y,[],nn);
		
		obj.extract_elements();
end

