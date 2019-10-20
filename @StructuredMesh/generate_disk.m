% Thu 15 Mar 09:52:03 CET 2018
%
%% generate semicircular domain
function obj = generate_disk(obj,R,Theta,n)
	% TODO check range

	theta = linspace(Theta(1),Theta(2),n(1));
	r     = linspace(R(1),R(2),n(2));
	obj.X = cvec(r)*cos(rvec(theta));
	obj.Y = cvec(r)*sin(rvec(theta));
end

