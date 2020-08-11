% Mon 12 Mar 11:54:08 CET 2018
% Thu 17 May 14:31:02 CEST 2018
%% match user specified boundary conditions (as line) with 
%% boundary of discretized computational domain
%
%% p*phi + (1-p)*d/db phi = rhs
% TODO allow for curved or multi-segment boundaries
% TODO allow boundary values to be expressed as functions
% function [p, rhs, bcid] = boundary_condition(obj, xb, yb, id, h)
function [p, rhs, bcid] = match_boundary_condition(obj, xb, yb, id, h);
	bc = obj.boundary_condition_s;

	% TODO, no magic number, make dependence on local mesh size
%	if (nargin()<10)
%		d_tol = 1e2;
%	end
	p   = zeros(size(xb));
	rhs = zeros(size(xb));
	bcid = zeros(size(xb));
	% assign to the boundary
	for idx=1:length(bc)
		[xp, yp, p_, d] =  Geometry.plumb_line(bc(idx).x(1),bc(idx).y(1),bc(idx).x(2),bc(idx).y(2),xb,yb,1);
		%d = hypot(xb-xbc(idx).y(idx,1),yb-xbc(idx).y(idx,2));
		fdx = d<bc(idx).d_tol;
		% bcid(d<d_tol) = idx;
		p(fdx)    = bc(idx).p;
		rhs(fdx)  = bc(idx).v; 
		bcid(fdx) = idx; 
	end
	% set outflow on all other (closed) boundaries to zero
	fdx = (0 == bcid);
	% 1-p == 1 : set normal derivative, not value
	p(fdx)   = 0;
	rhs(fdx) = 0;
end 

