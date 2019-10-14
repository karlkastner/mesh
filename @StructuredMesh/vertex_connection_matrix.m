% Thu 22 Nov 12:36:28 CET 2018
function A = vertex_connection_matrix(obj)
	nn = prod(obj.n);
	id = reshape((1:nn)',obj.n);
	% left and reight neighbour
%	right = flat(id(:,2:end));
%	left  = flat(id(:,1:end-1));

	valid = isfinite(obj.X);
	
	buf1 = [flat(id(2:end,:)); flat(id(:,2:end))];
	buf2 = [flat(id(1:end-1,:)); flat(id(:,1:end-1))];

	% left and top neighbour
	A = sparse(buf1,buf2,double(valid(buf1) & valid(buf2)), nn, nn);
	% mirror
	A = A+A';
end

