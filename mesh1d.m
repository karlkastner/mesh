% Fr 30. Okt 13:48:08 CET 2015
% Karl Kastner, Berlin
%
% mesh a 1d line segment with smooth (exponential) transition
%
function S = mesh1(L,dxl,dxr,dxc);
	a   = 0.2/dxc;
	% discretise domain
	S  = 0;
	% oversample
	o = 1;
	S_ = [];
	pe = exp(-a*L);
	qe = pe;
	while (S(end) < L)
		p = exp(-a*S(end));
		q = exp(-a*(L-S(end)));
		dx = dxl*p*(1-q)/(1-qe) + dxr*(1-p)/(1-pe)*q + dxc*(1-p*(1-q)/(1-qe) - (1-p)/(1-pe)*q);
		S(end+1) = S(end)+dx/o;
	end
	S = S(1:o:end);
	% normalise
	S = L/S(end)*S;
end % mesh1

