% Sa 5. Dez 16:17:19 CET 2015
% Karl Kastner, Berlin
%
%% import a mesh generated with triangle (ele and node)
%
function obj = import_triangle(obj,basename)
	elename = [basename,'.ele']
	fid = fopen(elename,'r');
	if (-1 == fid)
		error(['cannot open file', elename]);
	end
	% read number of lines
	str = fgets(fid);
	num = str2num(str);
	nele  = num(1);
	elem = zeros(nele,3);
	for idx=1:nele
		str = fgets(fid);
		num = str2num(str);
		if (idx ~= num(1))
			fprintf(1,'Warning: %d does not match its id %d\n',id,num(1));
		end
		elem(idx,:) = num(2:4);
	end
	fclose(fid);
	nodename = [basename,'.node'];
	fid = fopen(nodename,'r');
	if (-1 == fid)
		error(['cannot open file', nodename]);
	end
	% read number of lines
	str = fgets(fid);
	num = str2num(str);
	np  = num(1);
	point = zeros(np,2);
	for idx=1:np
		str = fgets(fid);
		num = str2num(str);
		point(idx,:) = num(2:3);
	end
	fclose(fid);

	obj.elem = elem;
	obj.point = point;
end % import_triangle

