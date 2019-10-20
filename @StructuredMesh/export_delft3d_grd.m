% Mi 30. Sep 15:53:20 CEST 2015
% Karl Kastner, Berlin
%
%% export mesh in deltares delft3D grd file format
function obj = export_delft3d_grd(obj,filename)
	% open output file
	fid = fopen(filename,'w');
	if (-1 == fid)
		error(['cannt open file ', filename, ' for writing']);
	end

	n_chunk = obj.n_chunk;

	X  = full(obj.X);
	n1 = size(X,1);
	n2 = size(X,2);

	X(isnan(X)) = obj.missing_value;

	% header
	fprintf(fid,'Coordinate System = Cartesian\n');
	fprintf(fid,'Missing Value     =   %19.17E\n',obj.missing_value);
	fprintf(fid,'%8d%8d\n',n2,n1);
	fprintf(fid,'%8d%8d%8d\n',[0 0 0]);
	
	% X-coordinate
	for idx=1:n1
		fprintf(fid,' ETA=%5d',idx);
		for jdx=1:n_chunk:n2
			% new row
			% print values
			fprintf(fid,'    %19.18e', X(idx,jdx:min(n2,jdx+n_chunk-1)));
			fprintf(fid,'\n');
			if (jdx < n2-n_chunk+1)
				fprintf(fid,'          ');
			end
		end
		if (0) %mod(n2,n_chunk)>0)
			fprintf(fid,'          ');
			fprintf(fid,'    %19.18e', X(idx,n_chunk*(floor(n2/n_chunk))+1:end));
			fprintf(fid,'\n');
		end
	end
	% Y-coodinate
	Y = full(obj.Y);
	Y(isnan(Y)) = obj.missing_value;
	for idx=1:n1
		fprintf(fid,' ETA=%5d',idx);
		for jdx=1:n_chunk:n2
			% new row
			% print values
			fprintf(fid,'    %19.18e', Y(idx,jdx:min(n2,jdx+n_chunk-1)));
			fprintf(fid,'\n');
			if (jdx < n2-n_chunk+1)
				fprintf(fid,'          ');
			end
		end
		if (0) %mod(n2,n_chunk)>0)
			fprintf(fid,'          ');
			fprintf(fid,'    %19.18e', Y(idx,n_chunk*(floor(n2/n_chunk))+1:end));
			fprintf(fid,'\n');
		end
	end

	fclose(fid);

	% export enc
	fid = fopen([filename(1:end-4),'.enc'],'w');
	if (-1 == fid)
		error(['cannt open file ', filename, ' for writing']);
	end
	fprintf(fid,'%6d %6d\n',1,1);
	fprintf(fid,'%6d %6d\n',size(X,2)+1,1);
	fprintf(fid,'%6d %6d\n',size(X,2)+1,size(X,1)+1);
	fprintf(fid,'%6d %6d\n',1,size(X,1)+1);
	fprintf(fid,'%6d %6d\n',1,1);
	fclose(fid);
end % export_grd

