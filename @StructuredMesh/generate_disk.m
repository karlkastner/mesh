% Thu 15 Mar 09:52:03 CET 2018
%Tue 22 Oct 09:32:10 +08 2019
%
%% generate semicircular domain
%% R1 : inner diameter
%% R2 : outer diameter
%% Theta(1) : start angle
%% Theta(2) : end angle
%% n(1) : along channel number of points
%% n(2) : across channel number of points
function obj = generate_disk(obj,R,Theta,n)
	if (length(R)==1)
		R = [0,R];
	end
	if (length(Theta) == 1)
		Theta = [0,Theta];
	end
	% TODO check range

	theta = linspace(Theta(1),Theta(2),n(1));
	r     = linspace(R(1),R(2),n(2));
	obj.X = cvec(r)*cos(rvec(theta));
	obj.Y = cvec(r)*sin(rvec(theta));

	obj.extract_elements();
end

