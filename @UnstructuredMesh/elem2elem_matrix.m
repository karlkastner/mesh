% Sun  6 Nov 22:27:28 CET 2016
% Karl Kastner, Berlin
%
%% matrix with neighbourhood relations for each element
function A = element2element_matrix(obj)
	elem = obj.elem;
	n = obj.nelem;
	elem2elem = obj.elem2elem;
	row  = repmat((1:n)',3,1);
	col  = [ones(n,1);2*ones(n,1);3*ones(n,1)];
	fdx  = flat(elem2elem ~= 0);
	A = sparse(row(fdx),elem2elem(fdx),col(fdx),n,n);
	fdx = all(obj.edge2elem,2);
	A_ = sparse(obj.edge2elem(fdx,1),obj.edge2elem(fdx,2),ones(sum(fdx),1),n,n);
	A_ = A_+A_';
	D = (A==1) - (A_==1);
	max(abs(D(:)))
	A = A_;
end

