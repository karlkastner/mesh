% Wed 23 May 13:06:03 CEST 2018
%% mesh a 1D channel, where boundaries are given as polygon
%% TODO, this should better use voronoi-tesselation (see centreline class)
function [smesh_,Pc,width,len] = mesh_polygon(obj,shp,ds,nn)
	Pc   = zeros(2,0);
	area = [];
	len  = [];
	% TODO, this only works, if the start point is a corner point
	% TODO, warn if there are intermediate NAN values, or lines cross in end
	shp  = Shp.remove_nan(shp);
	for sdx=1:length(shp)
		n = length(shp(sdx).X);
		P = [rvec(shp(sdx).X);
                     rvec(shp(sdx).Y)];
		% quick fix, skip point 1 and 2
		id = [2;
                      n-1];
		k = 1;
		area_ = [];
		while (id(1,k) < id(2,k));
%		plot([P(1,id(1,k));
%		      P(1,id(2,k))], ...
%		      [P(2,id(1,k));
%		      P(2,id(2,k))]);
%		hold on
 
		d1 = Geometry.distance2(P(:,id(1,k))',P(:,id(2,k)-1)');
		d2 = Geometry.distance2(P(:,id(2,k))',P(:,id(1,k)+1)');
		
%		sqrt([d1,d2])
		if (d1 > d2)
			% advance P1
			id(1,k+1) = id(1,k)+1;
			% keep
			id(2,k+1) = id(2,k);
			area_(k) = Geometry.tri_area( [P(1,id(1,k)),P(1,id(2,k)),P(1,id(1,k+1))], ...
					  	      [P(2,id(1,k)),P(2,id(2,k)),P(2,id(1,k+1))]);
		else
			% keep P
			id(1,k+1) = id(1,k);
			% advance P
			id(2,k+1) = id(2,k)-1;
			area_(k) = Geometry.tri_area( [P(1,id(1,k)),P(1,id(2,k)),P(1,id(2,k+1))], ...
					  	      [P(2,id(1,k)),P(2,id(2,k)),P(2,id(2,k+1))]);
		end
		k = k+1;
		% save indices for current lines
%		idm(end+1) = [i1; i2];
%		aa = Geometry.tri_area( [P1(i1,1),P2(i2,1),P(ia,1)], ...
%					[P1(i1,2),P2(i2,2),P(ia,2)]);
%		ab = Geometry.tri_area( [P1(i1,1),P2(i2,1),P(ib,1)], ...
%					[P1(i1,2),P2(i2,2),P(ib,2)]);
%		if (abs(aa) > abs(ab))
%			% push new centre
%			Pc = []
%			% push new width
%			W(idx) = 		
%		end
		%if (id(1) == ir)
		%	break;
		%end
		end % while
	area_ = abs(area_);
	%id(:,1) = [];
	id(:,end) = [];
	area_ = area_(1:end-1);
	% mid-points
	Pc_  = 0.5*(P(:,id(1,:)) + P(:,id(2,:)));
	len_   = hypot(diff(Pc_(1,:)),diff(Pc_(2,:)));
	len_(end+1) = len_(end);
	area_(end+1) = area_(end);
	width_ = area_./len_;

	len{sdx} = len_;
	area{sdx} = area_;
	width{sdx} = width_;
	Pc{sdx} = Pc_;
	if (0)
		len  = [len,NaN,len_];
		area = [area,NaN,area_];
		Pc  = [Pc,[NaN; NaN], Pc_];
		[length(area),length(len),length(Pc)]
	end

	smesh_(sdx) = SMesh();
	smesh_(sdx).generate_from_centreline(Pc_(1,:),Pc_(2,:),width_,ds,nn);

	end % for sdx

end

