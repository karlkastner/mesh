% Mi 27. Jan 12:55:26 CET 2016
% Karl Kastner, Berlin
	
mshname = '/home/pia/phd/src/mesh/mat/kapuas-0200-0200.msh';
mesh = UnstructuredMesh();
mesh.import_msh(mshname);
mesh.remove_lonely_points();

level = 3;

mesh_A = mesh.segment(level);

figure(1);
clf();
mesh_A.plot();
colormap('lines');

