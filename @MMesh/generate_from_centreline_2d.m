% Fr 19. Sep 11:57:22 CEST 2014
% Karl Kastner, Berlin
%
% TODO allow number of segments to change
%
% sets up a simple quadrilateral mesh in S-N coordinates
% centreline (must be sorted in streamwise direction)
% input variables:
% cS : S (streamwise) coordinates of centreline
% cL : N (spanwise) coordinate of left bank
% cR : N (spanwise) coordinate of right bank
% input variables controlling ouptut resolution:
% S  : S coordinate of slices in S-direction (diff(S) is element width)
%        must be sorted in s-direction
% n  : n number of points per cross section
%        (n-1) is number of elements per cross section
% output variables:
% mesh.{X,Y,S,N} : point coordinates
% mesh.T         : point indices of elements (corners of the quadrilaterals)
% -> make it orthogonal to banks by using a spline along n
function [mesh sobj] = generate_from_centreline(centre, ds, dw, sobj, type, nn0)
	%cS,cL,cR,cX,cY,S,np,type,sobj)
	if (nargin() < 4)
		sobj = [];
	end
	if (nargin() < 5 || isempty(type))
		type = 'outer';
	end
	if (nargin() < 6)
		nn0 = [];
	end

	mesh   = MMesh();

	S0 = centre.seg.S0;
	% for each segment
	for sdx=1:centre.seg.n
		cW   = centre.seg.w{sdx};
		Sseg = centre.seg.S(sdx);
		cS   = centre.seg.Sc(sdx);
		[Xl Yl] = centre.seg.Pl(sdx);
		[Xr Yr] = centre.seg.Pr(sdx);

		% number of points in streamwise direction
		% if segment is too short, only points, but no elements are put
		ns = max(1,round((S0(sdx,2)-S0(sdx,1))/ds));

		% 1d-mesh along S (streamwise component)
		%S = Sseg(end)*(0:ns-1)'/ns;
		S = S0(sdx,1) + (S0(sdx,2)-S0(sdx,1))*(0:ns-1)'/ns;


		% resample sides
		% TODO, this should better be integrated, not interpolated
		W  =  interp1(cS,cW,S,'linear','extrap');
		R  =  0.5*W; %interp1(cS,0.5*cW,S,'linear','extrap');
		L  = -R; %interp1(cS,0.5*cW,S,'linear','extrap');
		Pl =  interp1(cS,[Xl Yl],S,'linear','extrap');
		Pr =  interp1(cS,[Xr Yr],S,'linear','extrap');

		% number of points in spanwise direction
		if (~isempty(nn0) && isnumeric(nn0))
			nn = nn0;
			nn = repmat(nn,ns,1);
		elseif (strcmp(lower(nn0),'constant'))
			nn = max(1,round(median(W)/dw))+1;
			nn = repmat(nn,ns,1);
		else
			nn = max(1,round(W/dw))+1;
			% ensure continuity, width must not differ by more than 2
			% and has at least 2 points
			% TODO latter can be relaxed to 1 for integration
			% TODO, decrease dS, if change of width too large
			for idx=1:length(nn)-1
				d = nn(idx+1)-nn(idx);
				if (abs(d) < 2)
					% hold if difference is not at least 2
					d = 0;
				else
					% limit absolute difference to to 2
					d = max(-2,min(2,d));
					% avoid that width falls below 2 points, e.g. one elemnt
					if (nn(idx)+d < 2)
						d=0;
					end
				end
				nn(idx+1) = nn(idx)+d;
			end
			%	nn(idx) = max(2, ...
                        %                 max(min(nn(idx),nn(idx-1)+2,nn(idx-1)-2)));
			%end % for idx
		end % if isnumeric


		% allocate output memory
		% SN-coordinates
		sumnn = sum(nn);
		mS = zeros(sumnn,1);
		mN = zeros(sumnn,1);
		mX = zeros(sumnn,1);
		mY = zeros(sumnn,1);
		mW = zeros(sumnn,1);
		mCid = zeros(sumnn,1);

		% element point indices
		% TODO this is more tricky when with changes
		mT = zeros((ns-1)*(max(nn)-1),4);

		% grid points and elements
		np  = 0;
		np0 = size(mesh.point,1);
		nt  = 0;
		for idx=1:ns
			nni = nn(idx);
			% point location in the cross section
			% TODO vectorise
			switch (type)
			case {'gauss'} % only for integration, this is an inner gauss scheme
				% gauss integration
				[w b] = int_1d_gauss(nni);
			case {'gauss_lobatto'}
				[w b] = int_1d_gauss(nni);
			case {'inner'} % inner scheme is only for integration
				w = 1/nni*ones(nni,1);
				b = (1:nni)'/(nni+1);
				b = [b, 1-b];
			case {'outer'}
				w = 1/nni*ones(nni,1);
				b = (0:nni-1)'/(nni-1);
				b = [b, 1-b];
			otherwise
				error('');
			end % switch type

			% points
			range     = np+(1:nni);
			mS(range) = S(idx);
			mN(range) = L(idx)*b(:,1)    + R(idx).*b(:,2);
			mX(range) = Pl(idx,1)*b(:,1) + Pr(idx,1)*b(:,2);
			mY(range) = Pl(idx,2)*b(:,1) + Pr(idx,2)*b(:,2);
			mW(range) = w; % for area integration
			mCid(range) = idx;

			% elements counterclockwise (ccw)
			if (idx < ns)
			switch (nn(idx+1)-nni)
			case {-2}
				% left triangle
				nt = nt+1;
				mT(nt,1:3) = np0+np+[1,2,nni+1];
				% central quadrilaterals
				for jdx=2:nni-2
					nt=nt+1;
					mT(nt,:) = np0+np+[jdx, jdx+1, jdx+nni, jdx+nni-1];
				end
				% right triangle
				nt = nt+1;
				mT(nt,1:3) = np0+np+[nni-1, nni, 2*nni-2];
			case {+2}
				% left triangle
				nt = nt+1;
				mT(nt,1:3) = np0+np+[1, nni+2, nni+1];
				for jdx=1:nni-1
					nt = nt+1;
					mT(nt,:) = np0+np+[jdx, jdx+1, jdx+nni+2, jdx+nni+1];
				end
				% right triangle
				nt = nt+1;
				mT(nt,1:3) = np0+np+[nni, 2*nni+2, 2*nni+1];
			otherwise % 0, cross section width does not change
				for jdx=1:nni-1
					mT(nt+jdx,:) = np0+np + [jdx jdx+1 jdx+nni+1 jdx+nni];
				end
				nt = nt+nni-1;
			end % switch nn(idx+1)-nni
			end % if (idx < ns)
			% increase point counter
			np = np + nni;
		end % for idx

		% head
		head{sdx} = np0+1:nn(1);
		% tail
		tail{sdx} = np0+np+1:nni-nni;
		% (ns-1)*nn+(1:nn);

		% concatenate to output
		mesh.point      = [mesh.point;  mX mY];
		mesh.elem       = [mesh.elem;   mT(1:nt,:)];
		mesh.weight     = [mesh.weight; mW];
		mesh.cid        = [mesh.cid;    mCid];
	end % for sdx

%	mesh.mesh_junctions(centre.seg.junction, centre.seg.id, head, tail, dw)

	mesh.edges_from_elements();
end % from_centreline


