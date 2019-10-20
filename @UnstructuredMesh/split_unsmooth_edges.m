% Mon  5 Dec 11:31:30 CET 2016
%% split unsmooth edges
function obj = split_unsmooth_edges(obj)
	l=obj.edge_length();
	A=obj.vertex_to_edge();
	fdx=find(A);
	A(fdx)=l(A(fdx));
	Ai=A;
	Ai(fdx)=1./A(fdx);
	% find points
	%fdx=2./max(Ai')<max(A');
	%plot(obj.X(fdx),obj.Y(fdx),'m.')
	% find edges
	%fdx=2./max(Ai)<max(A);

	flag  = zeros(obj.nedge,1);
	Aflag = A;
	% min length of edges at vertices
	minl  = 1./max(Ai');
	%maxl  = max(A');
	Aflag = A>0;
	Amin  = diag(sparse(minl))*(A>0);
	Amini = Amin;
	fdx   = find(Amini);
	Amini(fdx)=1./Amini(fdx);
	fdx   = 2./max(Amini)' < l;

%	for idx=1:np
%			
%	end

	% split edges
	obj.split_edge(fdx);
end

