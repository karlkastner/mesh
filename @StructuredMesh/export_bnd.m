% Sun 25 Feb 22:02:10 CET 2018
function obj = export_bnd(obj,filename)
	X   = obj.X;
	reflection_coefficient = 0;	
	base = 'boundary';

	% Z	water level
	% T	total discharge for boundary section
	boundary_type = 'Z';
	data_type = 'T';

	fid = fopen(filename,'w');
	if (fid <= 0)
		error('cannot open file for writing');
	end

	k=0;
	for idx=[1,size(X,1)]
	fdx = [0,find([isnan(X(idx,:)),1])];
	for jdx=1:length(fdx)-1
		k=k+1;
		%index   = [idx, fdx(jdx)+1, idx, fdx(jdx+1)-1];
		% note: delft3d interptretes 2 to n+1 as 1 to n for the second-index
		index   = [fdx(jdx)+1, idx+1, fdx(jdx+1)-1, idx+1];
		name = [base,'_',num2str(k)];
		fprintf(fid,'%20s',name);
		% data type
		fprintf(fid,' %c ',boundary_type);
		% time series
		fprintf(fid,' %c ',data_type);
		% begin i-index begin j-index  end i-index end j-index
		fprintf(fid,' %5d',index(:));
		fprintf(fid,' %e',reflection_coefficient);
		% line feed, carriage return
		fprintf(fid,'\n');
	end % for jdx
	end % for kdx

	fclose(fid);

%realmax('single')	
% TODO
%	filename = [filename(1:[max(1,end-4)),'.bct'];
%	fid = fopend(filename,'w');
%
%	fprintf(fid,
%table-name           'Boundary Section : 1'
%contents             'Uniform             '
%location             'Up                  '
%time-function        'non-equidistant'
%reference-time       20140606
%time-unit            'minutes'
%interpolation        'linear'
%parameter            'time                '                     unit '[min]'
%parameter            'total discharge (t)  end A'               unit '[m3/s]'
%parameter            'total discharge (t)  end B'               unit '[m3/s]'
%records-in-table     2
% 0.0000000e+000  5.0000000e+002  9.9999900e+002
% 5.2560000e+005  5.0000000e+002  9.9999900e+002
%table-name           'Boundary Section : 2'
%contents             'Uniform             '
%location             'Down                '
%time-function        'non-equidistant'
%reference-time       20140606
%time-unit            'minutes'
%interpolation        'linear'
%parameter            'time                '                     unit '[min]'
%parameter            'water elevation (z)  end A'               unit '[m]'
%parameter            'water elevation (z)  end B'               unit '[m]'
%records-in-table     2
% 0.0000000e+000  8.3130000e+001  8.3130000e+001
% 5.2560000e+005  8.3130000e+001  8.3130000e+001
%
%

% TODO bcc
end % export_bnd

