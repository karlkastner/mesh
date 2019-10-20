% Sun  5 Feb 17:28:27 CET 2017
% Karl Kastner, Berlin
%
%% first order first derivative discretisation matrix on the 1d mesh
%
function [D d edx pdx] = derivative_matrix_1d(obj)
	% get 1d elements
	[elem2 edx] = obj.elemN(2);
	pdx = false(obj.np,1);
	pdx(elem2(:)) = true;

	% get points
	X = obj.X;
	X = X(elem2);
	Y = obj.Y;
	Y = Y(elem2);
	if (1 ==size(elem2,1))
		X = rvec(X);
		Y = rvec(Y);
	end
	d.X  = diff(X,[],2);
	d.Y  = diff(Y,[],2);
	d.S2 = d.X.^2 + d.Y.^2;
	d.S  = hypot(d.X,d.Y);

	elem2 = double(elem2);
	% simple difference matrix
	ne = size(edx,1);
	bufd  = [edx,elem2(:,1), -ones(ne,1); 
                 edx,elem2(:,2), +ones(ne,1)];
	% along hypothenuse
	bufs  = [edx,elem2(:,1), -1./d.S;
	         edx,elem2(:,2), +1./d.S];
	% along x
	bufx  = [edx,elem2(:,1), -d.X./d.S2;
	         edx,elem2(:,2), +d.X./d.S2];
	% along y
	bufy  = [edx,elem2(:,1), -d.Y./d.S2;
	         edx,elem2(:,2), +d.Y./d.S2];

	D.d = sparse(bufd(:,1),bufd(:,2),bufd(:,3),obj.nelem,obj.np);
	D.s = sparse(bufs(:,1),bufs(:,2),bufs(:,3),obj.nelem,obj.np);
	D.x = sparse(bufx(:,1),bufx(:,2),bufx(:,3),obj.nelem,obj.np);
	D.y = sparse(bufy(:,1),bufy(:,2),bufy(:,3),obj.nelem,obj.np);

	% TODO, this blows up if dx is 0!
%	bufx = [elem2, 1./dX;
%                elem2(:,2), elem2(:,1), 1./dX];
%	bufy = [elem2, 1./dY;
%                elem2(:,2), elem2(:,1), 1./dY];
end % derivative_matrix_1d

