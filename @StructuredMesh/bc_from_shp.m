% 2015-09-29 17:41:56.150309175 +0200
% Karl Kastner, Berlin

function [BC, obj] = bc_from_shp(obj,shp,scale) %,nr,nc)

	if (nargin() < 2)
		scale = 1;
	end

	BC = []

	% for each element in shp
	for idx=1:length(shp)
		block = shp(idx).block;
		if (0 == block)
			% ignore all blocks marked with 0
			continue;
		end
	
		side  = shp(idx).side;
		link  = shp(idx).link;
		X     = shp(idx).X;
		Y     = shp(idx).Y;
		n     = scale*shp(idx).n;
		nr    = n;
		nc    = n;

		BC(block).(side).link = link;
		BC(block).(side).n    = n;
	
		% convert boundary into a parametric curve
		% TODO this can be improved by using splines
		dx = diff(shp(idx).X);
		dy = diff(shp(idx).Y);
		dS = sqrt(dx.*dx + dy.*dy);
		S  = [0;cumsum(cvec(dS))];

		% TODO : check topolgy of east / west / south north and completition of rectangle
		switch (side)
			case {'north'}
				if (X(1) < X(end))
					S0 = linspace(0,1,nc);
				else
					S0 = linspace(1,0,nc);
				end
			case {'east'}
				if (Y(end) > Y(1))
					S0 = linspace(0,1,nr);
				else
					S0 = linspace(1,0,nr);
				end
			case {'south'}
				if (X(1) < X(end))
					S0=linspace(0,1,nc);
				else
					S0 = linspace(1,0,nc);
				end
			case {'west'}
				if (Y(end) > Y(1))
					S0=linspace(0,1,nr);
				else
					S0 = linspace(1,0,nr);
				end
		end
		BC(block).(side).X_ = X;
		BC(block).(side).Y_ = Y;
		BC(block).(side).S_ = S;

		% interpolate position of X and Y
		% cubic seems to be necessary for extrapolation
		% normalise
		S = (1/S(end))*S;
		X = interp1(S,X,S0,'cubic');
		Y = interp1(S,Y,S0,'cubic');
		% export position to BC
		BC(block).(side).X   = X;
		BC(block).(side).Y   = Y;
		BC(block).(side).S   = S0;
	end % for idx (each element in shp)

	obj.BC = BC;

	% check that the mesh is valid
	obj.bc_isinvalid(BC);
	
end % function % shp2bc

