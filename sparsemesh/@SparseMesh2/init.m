% Sat 26 May 13:38:59 CEST 2018
% Karl Kästner, Berlin
%% initialize, segment sampling locations/times into blocks the sampled
%% data is lumped to
function init(obj,X)
	if (nargin()<5)
		field = 'default';
	end
	% re-initialize data
	obj.val = struct();
	% normalize S
	obj.S = obj.S/norm(obj.S);

	obj.fdx = all(isfinite(X),2);
	X = X(obj.fdx,:);

	% TODO, mahalanobis
	obj.n0         = size(X,1);
	obj.n          = ceil(obj.n0/obj.m);
	m = obj.m;
	X(end+1:obj.n*m,:) = NaN;

	x1     = reshape(X(:,1),m,obj.n);
	x1c    = nanmean(x1).';
	x2     = reshape(X(:,2),m,obj.n);
	x2c    = nanmean(x2).';
	obj.T = delaunayTriangulation(obj.S(1)*x1c,obj.S(2)*x2c);
end %

