% Wed 20 Feb 10:48:45 CET 2019
%% domain (channel) centreline along chosen dimension
function [xc,yc,l_,r_] = centreline(obj,dim)
	X = obj.X;
	Y = obj.Y;
	if (nargin()>1 && dim==2)
		X=X';
		Y=Y';
	end
	n  = size(X);
	xc = zeros(n(1),0);
	yc = zeros(n(1),0);
	k  = zeros(size(X));
	% last invalid index
	l  = zeros(size(X,1),1);
	X(:,end+1) = NaN;
	Y(:,end+1) = NaN;
	l_ = [];
	r_ = [];
	for idx=1:size(X,2)
		for jdx=1:size(X,1)
			if (isnan(X(jdx,idx)))
				% sum up
				if (idx-l(jdx) > 1)
					k(jdx) = k(jdx)+1;
					l_(jdx,k(jdx)) = l(jdx)+1;
					r_(jdx,k(jdx)) = idx-1;
					xc(jdx,k(jdx)) = mean(X(jdx,l(jdx)+1:idx-1));
					yc(jdx,k(jdx)) = mean(Y(jdx,l(jdx)+1:idx-1));
				end
				l(jdx) = idx;
			end
		end % for jdx
	end % for idx
	xc(xc==0) = NaN;
	yc(yc==0) = NaN;
end
