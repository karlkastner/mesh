% 2016-09-26 18:37:32.092880897 +0200
% Karl Kastner, Berlin

function obj = improve_global2(obj)
	opt = struct();
	opt.verbose = true;
	opt.project = @(XY,XYn) box_constraint(obj.elem,XY,XYn);


	%fun = @(P) objective_midpoint(obj.elem,reshape(P,[],2),obj.edge(obj.bnd,:));
	%fun = @(P) objective_angle_scaled(obj.elem,reshape(P,[],2),obj.edge(obj.bnd,:));
	%fun = @(P) objective_angle(obj.elem,reshape(P,[],2),obj.edge(obj.bnd,:));
	fun = @(P) objective_incircle_excircle(obj.elem,reshape(P,[],2),obj.edge(obj.bnd,:));

	P = cauchy2(fun, flat(obj.point(:,1:2)), opt);
	%P = nlcg(fun, flat(obj.point(:,1:2)), opt);
	P = reshape(P,[],2);
	obj.point(:,1:2) = P;
end

