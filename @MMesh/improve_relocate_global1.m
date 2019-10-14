% Sa 19. Dez 19:56:27 CET 2015
% Karl Kastner, Berlin
%
% iteratively improve angles to remove obtuse triangles
%
function [f g h obj] = improve_angle_global(obj, solver, sopt, varargin)

	if ( nargin() < 1 || isempty(solver) )
		% choose the non-linear conjugate-gradient as solver (2nd order)
		solver = @nlcg;
		% choose steest gradient descent as solver (1st order)
		% solver  = @cauchy2;
	end

	% fetch
	P     = obj.point();
	np    = obj.np;
	elem  = obj.elem;
	bnd3  = obj.bnd3; %boundary_chain();
	edge  = obj.edge;
	P     = [P(:,1);P(:,2)];
	
	% optimise
	% [P f g] = solver(@(P) MMesh.objective_angle(P,elem,bnd3),P,sopt,varargin{:});
	[P f g] = solver(@(P) MMesh.objective_angle(P,elem,bnd3),P,sopt,varargin{:});
	h = NaN;

	% write back
	obj.point = [P(1:np),P(np+1:2*np)];
end % improve_angle_global

