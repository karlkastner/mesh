% when the mesh has been modified / is not orthogonal
% this method regenerates the mesh to be orthogonal

function regenerate(obj)
	% TODO oversample
	% TODO for even number of grid lines
	
	X  = obj.X;
	Y  = obj.Y;
	Xc = obj.Xc;
	Yc = obj.Yc;
	S  = obj.S;

	ns = size(S,1);
	nn = size(S,2);

	% take over first and last cross section
	Xi(1,:)  = X(1,:);
	Xi(ns,:) = X(ns,:);
	Yi(1,:)  = Y(1,:);
	Yi(ns,:) = Y(ns,:);

	dX = cdiff(X);
	dY = cdiff(Y);

	% TODO implement also for even number of grid lines across channel
	if (1 == mod(nn,2))
		% odd number of lines / even number of volumes across channel

		% center index
		ic = (nn+1)/2;

		% centre coordinates
		Si       = S(:,ic);
		Xi(:,ic) = interp1(S,X(:,ic),Si);
		Yi(:,ic) = interp1(S,Y(:,ic),Si);
	
		% for each interior cross-section
		for idx=2:ns-1

		    % towards right bend
		    for jdx=ic+1:nn
		    	% plumb line towards next right centre line
		    	[x0,y0,dx,dy] = Geometry.linestring_plumb(Xc(:,jdx-1),Yc(:,jdx-1),Xi(idx,jdx-1),Yi(idx,jdx-1));

		    	% intersection with next right grid line (fix-point)
		    	[Xi(idx,jdx),Yi(idx,jdx)] = Geometry.linestring_intersect(X(:,jdx),Y(:,jdx),x0,y0,dx,dy);

		    end % for jdx

		    % towards left bend
		    for jdx=ic-1:-1:1
		    	% plumb line towards next right centre line
		    	[x0,y0,dx,dy] = Geometry.linestring_plumb(Xc(:,jdx),Yc(:,jdx),Xi(idx,jdx+1),Yi(idx,jdx+1));

		    	% intersection with next right grid line (fix-point)
		    	[Xi(idx,jdx),Yi(idx,jdx)] = Geometry.linestring_intersect(X(:,jdx),Y(:,jdx),x0,y0,dx,dy);
		    end % for jdx
		    
		end % for idx
	end % if nn is odd

	% take over result
	mesh.X = Xi;
	mesh.Y = Yi;
	% clear temp-vars
	mesh.S_ = [];
	mesh.N_ = [];

%		% direction
%		dxy = interp1(s,dxy,s0);
%		while (1)
%		% orthogonal direction
%		oxy = [-dxy(2),dxy(1)];
%		% write grid points to output
%		if (id = nn)
%			% bank reached
%			break;
%		end
%	end
%end % regenerate

