% Sun 20 May 13:14:00 CEST 2018
%
%% indices of boundary segments
%% id : index of boundary point
%% jd : index of 
function [id,jd,obj] = boundary_indices(obj)
	n = obj.n;
	% corners are assigned to boundary 1
	id = [ (1:n(1)), ...
                1 + n(1)*(1:n(2)-2), ...
               (1:n(1))+n(1)*(n(2)-1), ...
	        n(1)*(2:n(2)-1) ]';
	if (nargout()>1)
        % next inner point
	jd = [ (1:n(1))+n(1), ...
                2 + n(1)*(1:n(2)-2), ...
	       (1:n(1))+n(1)*(n(2)-2), ...
		n(1)*(2:n(2)-1)-1].';
	end
end

