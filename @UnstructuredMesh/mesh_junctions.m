% So 22. Nov 14:00:42 CET 2015
% Karl Kastner, Berlin
%
%% mesh junctions of a channel network
%
function mesh_junctions(obj, junction, seg, head, tail, dw)
	X = obj.point(:,1);
	Y = obj.point(:,2);

	% for each junction
	for idx=1:length(junction)
		% last point indices of connecting segments
		id = {};
		for jdx=1:length(junction(idx).sid)
			if (seg{junction(idx).sid(jdx)}(1) == junction(idx).pid)
				id{jdx} = head{junction(idx).sid(jdx)};
			else
			% TODO verify
				id{jdx} = tail{junction(idx).sid(jdx)};
			end
		end

		% connect junctions
		pid  = id{1};
		open = 2:length(id);
%		jdx=0;
		while (~isempty(open))

%		figure(idx)
%		jdx=jdx+1;
%		subplot(2,2,jdx)
%		plot(X(pid),Y(pid),'.-')
%		axis equal

			dmin = inf;
			rexist  = false;
			reverse = false;
			% get closest end point
			for odx_=1:length(open)
				odx = open(odx_);
				d = hypot(X(pid(end))-X(id{odx}(1)), Y(pid(end))-Y(id{odx}(1)));
				if (d < dmin)
					dmin = d;
					mo   = odx_;
					rexist = false;
					reverse = false;
				end
				d = hypot(X(pid(end))-X(id{odx}(end)), Y(pid(end))-Y(id{odx}(end)));
				if (d < dmin)
					dmin = d;
					mo   = odx_;
					rexist = false;
					reverse = true;
				end
				d = hypot(X(pid(1))-X(id{odx}(1)), Y(pid(1))-Y(id{odx}(1)));
				if (d < dmin)
					dmin = d;
					mo   = odx_;
					rexist = true;
					reverse = false;
				end
				d = hypot(X(pid(1))-X(id{odx}(end)), Y(pid(1))-Y(id{odx}(end)));
				if (d < dmin)
					dmin = d;
					mo   = odx_;
					rexist = true;
					reverse = true;
				end
			end
			if (rexist)
				pid = fliplr(pid);
			end
			if (reverse)
				id{open(mo)} = fliplr(rvec(id{open(mo)}));
			end

			if (dmin > dw)

			% mesh the in-between 1d-segment
			n   = round(dmin/dw);
			p   = (1:n-1)/n;
			x   = (1-p)*X(pid(end)) + p*X(id{open(mo)}(1));
			y   = (1-p)*Y(pid(end)) + p*Y(id{open(mo)}(1));
			np  = length(X);
			X   = [X; cvec(x)];
			Y   = [Y; cvec(y)];
			pid = [pid, np+(1:n-1)];

			else
				% snap points
				x = 0.5*(X(pid(end))+X(id{open(mo)}(1)));
				y = 0.5*(Y(pid(end))+Y(id{open(mo)}(1)));
				X(pid(end)) = x;
				X(id{open(mo)}(1)) = x;
				Y(pid(end)) = y;
				Y(id{open(mo)}(1)) = y;
			end

			% concatenate points
			pid = [pid, id{open(mo)}];
			open(mo) = [];

		end % end

%		figure(idx)
%		jdx=jdx+1;
%		subplot(2,2,jdx)
%		plot(X(pid),Y(pid),'.-')
%%		hold on
%		for kdx=1:3; plot(X(id{kdx}),Y(id{kdx}),'o','markersize',5*kdx); hold on; end
%		axis equal
		dmin   = hypot(X(pid(1))-X(pid(end)),Y(pid(1))-Y(pid(end)));
		if (dmin > dw)
			% mesh the segment between the last and first point
			n   = round(dmin/dw);
			p   = (1:n-1)/n;
			x   = (1-p)*X(pid(end)) + p*X(pid(1));
			y   = (1-p)*Y(pid(end)) + p*Y(pid(1));
			np  = length(X);
			X   = [X; cvec(x)];
			Y   = [Y; cvec(y)];
			pid = [pid, np+(1:n-1)];
		else
			% snap points
			x = 0.5*(X(pid(end))+X(pid(1)));
			y = 0.5*(Y(pid(end))+Y(pid(1)));
			X(pid(end)) = x;
			X(pid(1)) = x;
			Y(pid(end)) = y;
			Y(pid(1)) = y;
		end

		plot(X(pid),Y(pid),'.-')
		% triangulate the polygon
		[p,t] = mesh2d([X,Y]);

	end % for idx (each junction)
	% remove duplicate points from the mesh
end % mesh junctions

