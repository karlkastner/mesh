% Thu 22 Nov 12:38:53 CET 2018
%
% better than before, but causes dn in inner bends to be narrower than in outer bends
% (straightens the lines)
% better smooth p: i.e. fractional distance from left to right,
% this is complicated at the bif
% better: two neighbour smooth: smooth dn and ds with left/right, top bottom only 
% 
%
function [ds,obj] = smooth_laplacian(obj,opt)
	if (nargin()<2)
		opt = struct();
	end
	if (~isfield(opt,'relax'))
		opt.relax = 0.5;
	end
	if (~isfield(opt,'maxiter'))
		opt.maxiter = 10;
	end
	nn = prod(obj.n);
	% connection matrix
	A = obj.vertex_connection_matrix();
	% normalize
	n = sum(A,2);
	A = diag(sparse(1./n))*A;
	% delta matrix
	% ((1-p)I + p A) - I = (
	A = opt.relax*(A - speye(nn));

	% stack for X and Y
	AA  = [A,spzeros(nn);spzeros(nn),A];
	nn  = prod(obj.n);
	one = ones(nn,1);
	dx  = zeros(nn,1);
	dy  = zeros(nn,1);
	XY = [flat(obj.X); flat(obj.Y)];
	ds = zeros(opt.maxiter,2);
	for idx=1:opt.maxiter
		[bnd_dx,bnd_dy,bnd_id,iscorner] = obj.boundary_direction();
		dx(bnd_id(:,1)) = bnd_dx;
		dy(bnd_id(:,1)) = bnd_dy;
		dx(bnd_id(iscorner,1)) = 0;
		dy(bnd_id(iscorner,1)) = 0;
		one(bnd_id(:,1)) = 0;
	
		% projection matrix for dx and dy at boundary points
		P = [diag(sparse(dx.*dx)),diag(sparse(dx.*dy));
		     diag(sparse(dx.*dy)),diag(sparse(dy.*dy))];
		P = P + [diag(sparse(one)),spzeros(nn);
			 spzeros(nn),diag(sparse(one))];
	
		% smoothing
		dxy = (P*(AA*XY));
		XY = XY + dxy;
		ds_ = hypot(dxy(1:nn),dxy(nn+1:end));
		ds(idx,:) = [max(ds_),nanrms(ds_)];
	
		% write back has to occur in loop, for boundary direction	
		obj.X = reshape(XY(1:nn),obj.n);
		obj.Y = reshape(XY(nn+1:end),obj.n);
	end % for idx
end % smooth2

