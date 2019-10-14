% Wed 23 May 19:24:32 CEST 2018
% TODO fails for adjacent nan and nan
function [id] = corner_indices(obj)
	n = obj.n();
	id = [];
%	id_ = []

	% first row
	ndx = find([true,isnan(obj.X(1,:)),true]);
	for idx=2:length(ndx)
%		id(end+1,:) = [1,ndx(idx-1)];
%		id(end+1,:) = [1,ndx(idx)-2];
		id(end+1,:) = [1,ndx(idx-1),1,ndx(idx)-2];
	end

	% last row
	ndx = find([true,isnan(obj.X(n(1),:)),true]);
	for idx=2:length(ndx)
%		id(end+1,1:2) = [n(1),ndx(idx-1)];
%		id(end+1,1:2) = [n(1),ndx(idx)-2];
		id(end+1,:) = [n(1),ndx(idx-1),n(1),ndx(idx)-2];
	end

	% first column
	ndx = find([true;isnan(obj.X(:,1));true]);
	for idx=2:length(ndx)
%		id(end+1,1:2) = [ndx(idx-1),1];
%		id(end+1,1:2) = [ndx(idx)-2,1];
		id(end+1,:) = [ndx(idx-1),1,ndx(idx)-2,1];
	end

	% last column
	ndx = find([true;isnan(obj.X(:,n(2)));true]);
	for idx=2:length(ndx)
%		id(end+1,1:2) = [ndx(idx-1),n(2)];
%		id(end+1,1:2) = [ndx(idx)-2,n(2)];
		id(end+1,:) = [ndx(idx-1),n(2),ndx(idx)-2,n(2)];
		%id(end+1,1:2) = [ndx(1)-1,n(2)];
		%id(end+1,1:2) = [ndx(1)+1,n(2)];
	end
end

