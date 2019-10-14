% Sun 18 Nov 12:31:38 CET 2018
%
% depth in dat file is defined at volume centres (water leve point)
% first row, first column and last column are buffer
% but nast colum is not (only when outflow?)
%
% zb : (ne+2)*(me+2) = (np+1)*(mp+1)
%
function dep = read_dep(obj,name)
	fid = fopen(name,'r');
	if (fid <= 0)
		error('cannot open file for reading');
	end
	dep = fscanf(fid,'%e');
	fclose(fid);

	% virtual depth to bed level
	dep = -dep;
	
	if (prod(obj.n+1) == length(dep))
		n = obj.n;
		Z = reshape(dep,[n(2),n(1)]+1)';
		% remove buffer
		Z = Z(2:end-1,2:end-1);
		% element to point
		obj.Z = obj.interp_elem2point(Z);

		%obj.Z = reshape(Z,obj.n);
	else
		warning('input data dimension does not fit grid');
	end
end

