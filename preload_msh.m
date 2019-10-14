% Sat Mar 15 12:34:40 WIB 2014
% Karl Kastner, Berlin

function mesh = preload_msh(folder, filename, reload)
	matname = ['mat' filesep filename(1:end-4) '.mat'];
	shpname = ['mat' filesep filename(1:end-4) '.shp'];

	% load the mat file, if it was already preloaded
	if (2 == exist(matname,'file') && ~reload)
		load(matname);
		return;
	end
	mesh = Mesh();
	mesh.from_msh(filename);

	% export mesh to mat file for later faster read in
	save(matname,'mesh');
	mesh.export_shp(shpname);
end

