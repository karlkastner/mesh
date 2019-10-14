% Mon May  2 10:16:31 CEST 2016
% Karl Kastner, Berlin
%
% determine nearest boundary segment for each input coordindate
%
function idx = nearest_boundary(obj,x0,y0)
	% boundary mid points
	bnd = obj.edge(obj.bnd,:);
	X   = reshape(obj.X(bnd),[],2);
	Y   = reshape(obj.Y(bnd),[],2);
	Xc  = mean(X,2);
	Yc  = mean(Y,2);
	idx = knnsearch([Xc Yc],[cvec(x0),cvec(y0)]);
%	dx  = diff(obj.X(bnd),[],2);
%	dy  = diff(obj.Y(bnd),[],2);
end % nearest_boundary

