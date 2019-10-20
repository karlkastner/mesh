% Sun 25 Feb 15:01:07 CET 2018
%% read mesh in delft3D grd format
function read_delft3d_grd(obj,name)
	fid = fopen(name,'r');
	if (fid <= 1)
		error('could not open file for reading');
	end
	while (1)
		s = fgetl(fid);
		% end of file
		if (~ischar(s))
			error('end of file reached before end of header');
		end
		% text
		if (length(s)>0)
		if ('*' == s(1))
			% comment, nothing to do
		elseif (~isempty(regexp(s,'Missing Value')))
			id = strfind(s, '=');
			obj.missing_value = sscanf(s(id+1:end), '%g', 1);
		elseif (~isempty(regexp(s,'Coordinate System')))
			% TODO read
		else
			% end of header reached
			break;
		end
		else
			% skip empty line
		end % if length(s)>0
	end
	% read dimensions
	dim = sscanf(s,'%d');
	% read three dummy zeros
	fgetl(fid);
	% read x coordinate
	for idx=1:dim(2)
		[eta, n] = fscanf(fid,'%s=');
		val = fscanf(fid,'%e');
		if (val(1) ~= idx)
			error('here');
		end
		X(idx,:) = val(2:end);
	end
	% read y
	for idx=1:dim(2)
		[eta, n] = fscanf(fid,'%s=');
		val = fscanf(fid,'%e');
		if (val(1) ~= idx)
			error('here');
		end
		Y(idx,:) = val(2:end);
	end
	fclose(fid);
	% invalidate missing values
	fdx    = (obj.missing_value == X);
	X(fdx) = NaN;
	fdx    = (obj.missing_value == Y);
	Y(fdx) = NaN;
	% extract elements
	obj.X = X;
	obj.Y = Y;
	obj.extract_elements();
end % read_grd

