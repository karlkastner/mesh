% Tue 27 Nov 16:38:22 CET 2018
% TODO make this  plot edge_val
function plot_orthogonality(obj)
	X = obj.X;
	Y = obj.Y;
	eid = obj.edge;
	% edge point coordinates
	%xy1 = [X(eid(:,1),Y(eid(:,1))];
	%xy2 = [X(eid(:,2),Y(eid(:,2))];

	o = obj.orthogonality();
	o = acos(o);

	patch([X(eid(:,1))'; X(eid(:,2))'], ...
	      [Y(eid(:,1))'; Y(eid(:,2))'], [rvec(o);rvec(o)], ...
		'edgecolor','interp', ...
		'facecolor','none' ...
		);
	
%	plot([X(eid(:,1)
end

