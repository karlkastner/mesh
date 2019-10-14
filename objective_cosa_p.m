% Tue 25 Oct 15:19:41 CEST 2016
function [f g H] = objective_cosa_p(X,Y,cosa0,p)
	a = Geometry.tri_area(X,Y);
	if (~issym(a(1)) && any(a<0))
		f = NaN;
		g = NaN;
		H = NaN;
		return;
	end
	switch (nargout())
	case {1}
		% cos of angles
		%cosa  = Geometry.dot(X(:,3)-X(:,1),Y(:,3)-Y(:,1), ...
		%		     X(:,2)-X(:,1),Y(:,2)-Y(:,1));
		[cosa] = Geometry.ddot([X(:,1),Y(:,1)].',[X(:,2),Y(:,2)].',[X(:,3),Y(:,3)].');
	case {2}
		% inner derivative
		[cosa gc] = Geometry.ddot([X(:,1),Y(:,1)].',[X(:,2),Y(:,2)].',[X(:,3),Y(:,3)].');
	case {3}
		% inner derivative
		[cosa gc Hc] = Geometry.ddot([X(:,1),Y(:,1)].',[X(:,2),Y(:,2)].',[X(:,3),Y(:,3)].');
	end
	
	% objective function value
	f  = (cosa - cosa0).^p;

%	P = flat([[X(:,1),Y(:,1)].',[X(:,2),Y(:,2)].',[X(:,3),Y(:,3)].']);
%	g=grad(@(P) Geometry.ddot(P(1:2),P(3:4),P(5:6)),P);
%	g.'
%	P(1:2)
	%[dcx dcy] = Geometry.ddot(X,Y);

	if (nargout() > 1) 
		% outer derivative
		df = p.*(cosa - cosa0).^(p-1);
		% apply chain rule
		g = bsxfun(@times,gc,df);
		if (nargout() > 2)
			% apply chain rule twice
			ddf = p*(p-1)*(cosa-cosa0).^(p-2);
			% uppder diagonal of symmetric Hessian
			cdx=0;
			for idx=1:6
				for jdx=idx:6
					cdx = cdx+1;
					H(:,cdx) = gc(:,idx).*gc(:,jdx).*ddf + Hc(:,cdx).*df;
				end % for jdx
			end % for idx
		end % if nargout > 2
	end % if nargout > 1
end % objective_cosa_p

