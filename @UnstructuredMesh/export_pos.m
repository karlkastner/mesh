% Thu 24 Nov 14:07:08 CET 2016
% Karl Kastner, Berlin
%
%% export triangles and vertex values to gmsh pos-file format (x,y,z,val)
%% intended for re-meshing with values representing local mesh size
function obj = export_pos(obj,oname,V)
	X = obj.elemX();
	Y = obj.elemY();
	Z = obj.elemZ();
	if (isempty(Z))
		Z = zeros(size(X));
	end
	V = V(obj.elem);

	fid = fopen(oname,'w');
	if (fid <= 0)
		error('here');
	end
	

	% export the mesh as pos
	fprintf(fid,'View "background mesh" {\n');
	%           x1,y1,z1,
	fprintf(fid,'ST(%f,%f,%f,%f,%f,%f,%f,%f,%f){%f,%f,%f};\n', ...
	  [X(:,1),Y(:,1),Z(:,1),X(:,2),Y(:,2),Z(:,2),X(:,3),Y(:,3),Z(:,3),V]');
	fprintf(fid,'};\n');
	fclose(fid);
end % export_pos

