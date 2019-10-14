function Z = interp_elem2point(obj,Z)
	n = obj.n;
size(Z)
imagesc(Z)
pause
	Z = interp1((1:n(1)-1)/n(1),Z,(0:n(1)-1)/(n(1)-1),'linear','extrap');
size(Z)
	Z = interp1((1:n(2)-1)/n(1),Z',(0:n(2)-1)/(n(1)-1),'linear','extrap')';
end
