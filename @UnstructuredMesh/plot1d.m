% Mon 20 Feb 17:07:08 CET 2017
%% plot 1D mesh
function plot1d(obj,C)
	if (nargin() < 2)
		C = obj.Z;
	end
	elem2 = obj.elemN(2);
	X  = obj.X;
	Y  = obj.Y;
	W  = obj.pval.width;
	eW = W(elem2);
	eX = X(elem2);
	eY = Y(elem2);
	eC = C(elem2);
	dX = diff(eX,[],2);
	dY = diff(eY,[],2);
	dS = hypot(dX,dY);
	dX = dX./dS;
	dY = dY./dS;

	ne = size(eX,1);

	method = 0;
	switch (method)
		% rectangular elements, no smooth transition between elements
		pX = [eX(:,1) + 0.5*dY.*eW(:,1), eX(:,1) - 0.5*dY.*eW(:,1) ...
		      eX(:,2) - 0.5*dY.*eW(:,2), eX(:,2) + 0.5*dY.*eW(:,2)];
		pY = [eY(:,1) - 0.5*dX.*eW(:,1), eY(:,1) + 0.5*dX.*eW(:,1) ...
		      eY(:,2) + 0.5*dX.*eW(:,2), eY(:,2) - 0.5*dX.*eW(:,2)];
		C = mean(eC,2);
		patch(pX',pY',C');
	case {1}
	end
end

