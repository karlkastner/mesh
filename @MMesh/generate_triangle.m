% Sa 5. Dez 15:35:07 CET 2015
% Karl Kastner, Berlin
%
% generate a mesh from a polygon using the programme "Triangle"
%
function obj = generate_triangle(obj, iname, minangle, maxangle, maxarea)

	[suf base] = suffix(iname);

	if (nargin() < 3)
		minangle = [];
	end
	if (nargin() < 4)
		maxangle = [];
	end
	if (nargin() < 5)
		maxarea = [];
	end

	switch (suf)
	case {'shp'}
		printf('Converting shapefile to poly file');
		shp = Shp.read(iname);
		polyname = [base,'.poly'];
		Shp.export_poly(shp, polyname);
	case {'poly'}
		polyname = iname;
	otherwise
		error('unknown file type')
	end

	optstr = [];
	% ensure conformity
	optstr = [optstr,' -D '];
	% discard points that are not vertices of the final triangulation
	optstr = [optstr,' -j '];
	% specify minimum angle constraint
	if (~isempty(minangle))
		optstr = [optstr,' -q',num2str(minangle),' '];
	end
	% specify maximum angle constraint
	% requires acute patch
	if (~isempty(maxangle))
		optstr = [optstr,' -U',num2str(maxangle),' '];
		cmd    = ' acute ';	
	else
		cmd    = ' triangle ';
	end

	% specify maximum triangle area
	if (~isempty(maxarea))
		optstr = [optstr,' -a',num2str(maxarea),' '];
	end

	% acute must be in search path
	command = ['LD_LIBRARY_PATH= ',cmd,' ',optstr,' ',polyname];
	disp(command);
	system(command);
	%command = ['LD_LIBRARY_PATH= ',ROOTFOLDER,'src/acute/acuteSoftware/acute -q15 -a',num2str(area),' -U92 ',polyname];
%	command = ['LD_LIBRARY_PATH= ~/phd/src/acute/acuteSoftware/acute -U91 ',polyname];
%	command = ['LD_LIBRARY_PATH= ~/phd/src/acute/acuteSoftware/acute -a' num2str(area) ' -U91 ',polyname];
%	command = ['LD_LIBRARY_PATH= /home/pia/phd/src/acute/triangle/triangle -a' num2str(area) ' -q34 ',polyname];
%	command = ['LD_LIBRARY_PATH= /home/pia/phd/src/acute/triangle/triangle -a' num2str(area) ' -q34 ',polyname];

%	mesh = MMesh();
	obj.import_triangle([polyname(1:end-4),'1']);
end

