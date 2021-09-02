% Thu  3 Sep 18:28:04 +08 2020
%
%% export initial sediment_thickness file for Delft3D4
%
function obj = export_delft3d_inisedthick(obj,name,thick)
	% TODO, make ncol an object member
	ncol = 12;
	fid  = fopen(name,'w');
	if (fid <= 0)
		error('cannot open file for writing');
	end
	
	% padd border values
	n = size(thick);
	n_ = obj.n;
if (n(1)+1 == n_(1))
	%thick = rvec(thick);
	thick = [thick(:,1),thick,thick(:,end)];
	thick = [thick(1,:); thick; thick(end,:)];
elseif(n(1) == n_(1))
	%thick = rvec(thick);
	thick = inner2outer(inner2outer(thick,1),2);
else
	error('here');
end
	write_(thick);
	fclose(fid);

function write_(Z)
	if(0)
	format = [repmat('  % .7E',1,ncol),'\n'];
	for idx=1:size(Z,1)
		fprintf(fid,format,Z(idx,:));
		if(mod(size(Z,2),12)>0)
			fprintf(fid,'\n');
		end
	end
	fprintf(fid,'\n');
	else
	for idx=1:size(Z,1)
	for jdx=1:size(Z,2)
		fprintf(fid,'  % .7E',Z(idx,jdx));
	end
		fprintf(fid,'\n');
	end
	end
end

end

