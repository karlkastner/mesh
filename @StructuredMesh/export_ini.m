% Mon  3 Jun 11:08:23 CEST 2019
% sec A 2.9 in manual
function export_ini(obj,name,zs,u,v,c,nz)
	fid  = fopen(name,'w');
	if (fid <= 0)
		error('cannot open file for writing');
	end
	n = obj.n+1;
	format = [repmat('  % .7E',1,n(2)),'\n'];

	% water level
	export(zs,1);
	% U-velocities (Kmax matrices).
	export(u,nz);
	% V-velocities (Kmax matrices).
	export(v,nz);
	% Salinity, only if selected as an active process (Kmax matrices).
	% Temperature, only if selected as an active process (Kmax matrices).
	% Constituent number 1, 2, 3 to the last constituent chosen, only if selected (Kmax matrices).
	export(c,nz); % TODO also for nc
	% Secondary flow (for 2D simulations only), only if selected as an active process (one ma-trix).
	fclose(fid);

function export(val,nz)
	if (isempty(val))
		val = 0;
	end
	if (isscalar(val))
		val = repmat(val,n);
	end
	if (size(val,1) == n(1)-1)
		val = inner2outer(val);
	end
	if (size(val,2) == n(2)-1)
		val = inner2outer(val')';
	end
	for jdx=1:nz
	for idx=1:n(1)
		fprintf(fid,format,val(idx,:));
	end % idx
	end		
end

end % export_ini

