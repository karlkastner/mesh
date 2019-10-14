% 2018-02-25 14:25:14.309999107 +0100
function s = statistic(obj)
	ds = hypot(diff(obj.X),diff(obj.Y));
	s.ds.max = max(max(ds,[],2));
	s.ds.med = nanmedian(ds(:));
	s.ds.min = min(min(ds,[],2));
	printf('ds: max %g med %g min %g max/min %g\n', ...
		s.ds.max,s.ds.med,s.ds.min,s.ds.max/s.ds.min); 
	dn = hypot(diff(obj.X,[],2),diff(obj.Y,[],2));
	s.dn.max = max(max(dn,[],2));
	s.dn.med = nanmedian(dn(:));
	s.dn.min = min(min(dn,[],2));
	printf('dn: max %g med %g min %g max/min %g\n', ...
		s.dn.max,s.dn.med,s.dn.min,s.dn.max/s.dn.min); 
	s.aspect = s.ds.med./s.dn.med;
	printf('aspect ds/dn : %g dn/ds %g\n',s.aspect,1./s.aspect);
end
