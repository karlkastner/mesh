% Wed 23 May 16:08:05 CEST 2018
%% snap two meshes that connect at their domain boundaries
function [id_,jd_,obj] = snap(obj,obj2,dmax,pflag)
	id_ = [];
	jd_ = [];
	[id] = obj.corner_indices();
	[jd]  = obj2.corner_indices();

	% for each boundary in mesh 1
	for idx=1:size(id,1)
		% for each boundary in mesh 2
		for jdx=1:size(jd,1)
			% for each of the two end points of boundary
			% TODO, flipped
			for p1=1
				d1 = hypot(obj.X(id(idx,1),id(idx,2))-obj2.X(jd(jdx,1),jd(jdx,2)), ...
					  obj.Y(id(idx,1),id(idx,2))-obj2.Y(jd(jdx,1),jd(jdx,2)));
				d2 = hypot(obj.X(id(idx,3),id(idx,4))-obj2.X(jd(jdx,3),jd(jdx,4)), ...
					   obj.Y(id(idx,3),id(idx,4))-obj2.Y(jd(jdx,3),jd(jdx,4)));
				% TODO relative distance
				if (d1<dmax && d2 < dmax)
					disp(sprintf('snapping %g : %d,%d %d,%d with %d,%d %d,%d \n',d1+d2,id(idx,:),jd(jdx,:)));
					if (pflag)
						plot(obj2.X(jd(jdx,[1,3]),jd(jdx,[2,4])),obj2.Y(jd(jdx,[1,3]),jd(jdx,[2,4])),'r.-');
					end % if
					% snap the corners
					obj.X(id(idx,1),id(idx,2)) = obj2.X(jd(jdx,1),jd(jdx,2)); 
					obj.Y(id(idx,1),id(idx,2)) = obj2.Y(jd(jdx,1),jd(jdx,2));
					obj.X(id(idx,3),id(idx,4)) = obj2.X(jd(jdx,3),jd(jdx,4)); 
					obj.Y(id(idx,3),id(idx,4)) = obj2.Y(jd(jdx,3),jd(jdx,4));
					% TODO align inner points
					id_ = [id_, id(idx,:)];
					jd_ = [jd_, jd(jdx,:)];
				end % if
			end
		end % jdx
	end % idx
end % snap

