% Sun 25 Feb 22:02:10 CET 2018
%% export the boundary in delft3d compatible format 
% TODO bcc
function obj = export_delt3d_bnd(obj,filename)
	X   = obj.X;
	reflection_coefficient = 0;	
	base = 'boundary';

	% TODO variable
	% Z	water level
	% T	total discharge for boundary section
	boundary_type = 'Z';
	data_type     = 'T';

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

end % export_bnd

