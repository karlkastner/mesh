% 2015-12-20 00:39:32.265887148 +0100
% Karl Kastner, Berlin
%% export mesh in GMSH msh format
function export_msh(obj,filename)
	fid = fopen(filename,'w');
	if (-1 == fid)
		error(['Cannot open file ', filename]);
	end

	% put header
	% TODO no magic numbers
	fprintf(fid,['$MeshFormat\n', ...
		    '2.2 0 8\n', ...
		    '$EndMeshFormat\n'] ...
		);
	% put vertices
	fprintf(fid,'$Nodes\n');
	fprintf(fid,'%d\n',obj.np);
	for idx=1:obj.np
		fprintf(fid,'%d %g %g %g\n',idx,obj.point(idx,1:2),0);
		%fprintf(fid,'%d %g %g %g\n',idx,obj.point(idx,1:2));
	end
	fprintf(fid,'$EndNodes\n');

	% TODO put boundary edges
	% 1 15 2 0 1 1
	% put triangles
	fprintf(fid,'$Elements\n');
	fprintf(fid,'%d\n',obj.nelem);
	n = 0;
	for jdx=3:3 %size(obj.elem,2)
	elem = obj.elemN(jdx);
	for idx=1:size(elem,1);
		fprintf(fid,'%d %d %d %d %d %d %d %d\n',idx,2,2,0,1,elem(idx,1:jdx));
%		for kdx=1jdx)
%		end
%		fprintf(fid,'
	end
	end
	fprintf(fid,'$EndElements\n');
	fclose(fid);
end % export_msh

