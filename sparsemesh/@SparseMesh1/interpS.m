% Mon 28 May 18:28:47 CEST 2018
% Karl Kästner, Berlin
%% interpolate data stored in field "field" to coordinates Xi,
%% do not ignore invalid data
function vi = interpS(obj,field,Xi)
	n = size(Xi,1);
	% allocate memeory
	vi = interp1(obj.T.x,obj.val.(field),Xi,'linear',NaN);
end % interpS

