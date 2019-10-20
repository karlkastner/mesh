% Sun 25 Feb 21:24:41 CET 2018
%
%% export bathymetry data in Delft3D dep-format
%
%function obj = export_dep(obj,name,flag)
function obj = export_dep(obj,name,flag)
	ncol = 12;
	fid  = fopen(name,'w');
	if (fid <= 0)
		error('cannot open file for writing');
	end
	Z = obj.Z;
	% Note: there seems to have been a redefinition of depth in delft3d,
	% old meshes requires z = -z
	Z = -Z;
	% TODO : 
	if (nargin() < 3)
		flag = 2;
	end
	% Z = obj.point2elem + add buffer
%	if (nargin() > 2)
	switch (flag)
	case {1}
%	Z = [Z(:,1),Z];
%	Z = [Z,Z(:,1)];
%	Z = [Z(1,:);Z];
		
		n = size(Z);
		Z = interp1((1:n(2))/(n(2)+1)',Z',(0:n(2))/n(2),'linear','extrap')';
		Z = interp1((1:n(1))/(n(1)+1),Z,(0:n(1))/n(1),'linear','extrap');
	case {2}
		Z = [Z(:,1),Z,Z(:,end)];	
		Z = [Z(1,:);Z;Z(end,:)];	
	otherwise
		% nothing
	end
	size(Z)
%	Z = Z';
	fdx = isnan(Z);
	Z(fdx) = 0;

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
%	end
	fclose(fid);
end

