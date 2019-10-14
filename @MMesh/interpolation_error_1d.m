% Thu 22 Jun 12:34:06 CEST 2017
function [rmse rmsei obj] = interpolation_error_1d(obj,val,order)
	if (nargin()<3 || isempty(order))
		order = 0;
	end
	
	L    = abs(obj.element_length()); % area/volume?
	switch (order)
	case {0} % for constant interpolation
		% s2 =  1/L int (f-f*)^2 dl = 1/3 f'^2 L^2

		% derivative matrix
		Dx    = obj.derivative_matrix_1d();
		% first derivative (constant, thus midpoint rule is exact)
		dvdx = (Dx*val);
		% mean square error per element
		msei  = 1/3*dvdx.^2;

		% .*L.^2;
%		e2 = obj.elemN(2);
%		X  = obj.X;
%		eX = X(e2);
%		% element length
%		L = abs(eX(:,2)-eX(:,1));
		% interpolation matrix
%		A = vander_1d(X.',1);
%		Ai = inv2x2(A);
		% get derivative
%		c = matvec3(A,val(e2).');
%		c = squeeze(c);
%		f1 = c(2,:).';
%		df = f1;
	case {1} % for linear interpolation
		% s^2 = 1/L int (f-f*)^2 = 1/20 f''^2 L^4
		% determine f'' for each element

		% get second derivative
		e2e = obj.elem2elem();
		e2  = obj.elemN(2);
		% add points of neighbours to me
		for idx=1:size(e2e,2)
			fdx = e2e(:,idx) ~= 0;
			e2(fdx,end+1:end+2) = e2(e2e(fdx,idx),1:2);
		end
		% remove duplicates
		e2(e2==0) = NaN;
		e2 = unique_columnwise(e2')';
		n  = obj.np;
		e2(isnan(e2)) = n+1;
		% TODO, quick fix
		e2 = min(e2,length(val));
		% set up quadratic interpolation matrices
		X   = obj.X;
		X(n+1) = NaN;
		% TODO this is not optimal, as fourth point is discarded
		eX  = X(e2(:,1:3));
		% shift for stability
	%	eX = bsxfun(@minus,eX,eX(:,1));
		A   = vander_1d(eX.',2);
		%A = transpose3(A);
		Ai  = inv3x3(A);
		% get coefficients
		c   = matvec3(Ai,val(e2(:,1:3)).');
		c_ = c(end,:)';
		c = squeeze(c);
	if (0)
		figure()
	%eX
		plot(flat(eX),flat(val(e2(:,1:3))),'.')
		hold on
		D2 = derivative_matrix_2_1d(length(val),1/2);
		D1 = derivative_matrix_1_1d(length(val),1/2);
	
		f2_ = D1*val;
		f2_(:,2) = D2*val;	
		f2_(:,3) = D1*(D1*val);	
		
		plot(eX(:,1),[c(end,:)'])
		hold on
		plot([eX(:,1); 2*eX(end,1)-eX(end-1,1)], f2_)
		ylim([-10 10])
		pause
	end
		% why 2?
		f2  = 2*c(end,:).';
		df = f2;
	
		% get element length
		X   = obj.elemX;
		L   = abs(X(:,2)-X(:,1));
		% rms interpolation error per element
		msei  = 1./20*f2.^2.*L.^4;
		%mse  = 1./6*f2.^2.*L;
		% total rms error
	otherwise
		error('not yet implemented')
	end % switch
	rmse   = sqrt(sum(msei.*L)./sum(L));
	rmsei  = sqrt(msei);
end % interpolation_erro_1d

