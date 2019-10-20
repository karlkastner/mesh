% Fri 18 May 09:41:48 CEST 2018
%% plot connected vertices, see vertex_connection_matrix.m
function plot_coupling(obj,A)
	X = obj.X;
	Y = obj.Y;
	[id,jd] = find(A);
	X_ = [X(id),X(jd),NaN(size(id))];
	Y_ = [Y(id),Y(jd),NaN(size(id))];
	plot(flat(X_'),flat(Y_'),'-k');
	hold on
	plot(X,Y,'.k')
	hold off
%	clf
%	spy(A)
%pause
end

