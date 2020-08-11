% Thu 14 May 13:14:31 +08 2020
function t = edge_direction(obj,fdx,flag)
	if (nargin>1)
		edge = obj.edge(fdx,:);
	else
		edge = obj.edge;
	end
	Xb = reshape(obj.X(edge),[],2);
	Yb = reshape(obj.Y(edge),[],2);
	t = [diff(Xb,[],2),diff(Yb,[],2)];
	t = t./hypot(t(:,1),t(:,2));

	% sign with respect to first element for boundary
	if (nargin()>2 & flag)
		Xt = reshape(obj.X(obj.elem(obj.edge2elem(fdx,1),:)),[],3);
		Yt = reshape(obj.Y(obj.elem(obj.edge2elem(fdx,1),:)),[],3);
		% third point coordinate
		X3 = sum(Xt,2)-sum(Xb,2);
		Y3 = sum(Yt,2)-sum(Yb,2);
		X = [Xb,X3];
		Y = [Yb,Y3];
		for idx=1:size(t,1)
			A = vander_2d(X(idx,:).',Y(idx,:).',1);
			a = det(A);
			t(idx,:) = sign(a)*t(idx,:);
		end
	end
end

