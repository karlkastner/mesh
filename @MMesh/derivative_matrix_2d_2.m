% Thu 18 Jan 14:48:39 CET 2018
% 

% require that values at edge mid-points are identical between neighbouring elements
function [Dxx Dxy Dyy Dx Dy] = derivative_matrix_2d_2(obj)
	elem       = obj.elemN(3);
	edge2elem  = obj.edge2elem();
%	e2e = obj.edge2elem();

	% promote elements

	% for each element
	for idx=1:size(elem,1)
		for jdx=1:3
			% for each corner
			% add a rown enforcing equality with known values
			A(idx,:) =
		end % for jdx
	end % for idx

	% for each edge
	for idx=1:size(edge2elem,1)
		% if two adjoing elements
		if (edge2elem(idx,1)>0 && edge2elem(idx,2)>0)
			% for each of the two adjoint elements
			for jdx=1:2
				% add a row enforcing identical values at the edge-midpoint
				A(idx+np,:) =
			end
		else
			% mirror values and coordinates at edges (ghost elements, points and values)
			A(idx+np,:) =
		end
	end %f or idx
	
	% value at corners and edge midpoints
	iA = inv(A);
	%val_ = A \ val;
	
	% set up the vandermonde matrix for the derivative for the six-point triangles
	Ad = 

	% coefficients of the derivatives
	c = A \ Ad;

	% set coefficients
	buf      = zeros(,2) 
	buf(:,1) =
	buf(:,2) =
	
	Dxx = sparse(buf(:,1),buf(:,2),
	Dxy = sparse(buf(:,1),buf(:,2),
	Dyy = sparse(buf(:,1),buf(:,2),
	if (nargout()>3)
		Dx = sparse(buf(:,1),buf(:,2),
		Dy = sparse(buf(:,1),buf(:,2),
	end
end

