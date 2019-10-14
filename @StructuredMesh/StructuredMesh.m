% Di 27. Okt 20:04:49 CET 2015
% Karl Kastner, Berlin
classdef StructuredMesh < handle
	properties
		X
		Y
		Z
		E
		C
		BC
		elem
		removed

		% neighbour matrices
		Left_;
		Right_;
		Up_;
		Down_;
		no_Left;
		no_Right;
		no_Up;
		no_Down;
		
		S_
		N_


		% derivative matrices
		Dx_
		Dy_
		D2x_
		Dxy_
		D2y_
		L_

		missing_value = 0;
		n_chunk = 5;
		maxit  = 15;
		abstol = 1e-7;

		dual_mesh_;
	end % properties
	methods (Static)
		smesh = compose_domain(folder,name_C,ddb_str,ds_max);
	end % methos static
	methods
		function obj = StructuredMesh()
		end

		% TODO, centroid
		function [smesh,obj] = dual_mesh(obj)
			if (~isempty(obj.dual_mesh_))
				smesh = obj.dual_mesh_;
			else
			[Xc,Yc] = obj.elem_centre();
			smesh = SMesh();
			smesh.X = Xc;
			smesh.Y = Yc;
			mesh.dual_mesh_ = smesh();
			end
		end

		function n = n(obj)
			n = size(obj.X);
		end
	
		function nn = nn(obj)
			nn = numel(obj.X);
		end

		function [id, jd, ij, obj] = nearest_vertex(obj,xy0)
			ij = knnsearch([flat(obj.X),flat(obj.Y)],xy0);
			[id,jd] = ind2sub(obj.n,ij);
		end

		%function edge_u = edgeu(obj)
		%end

		function [dx,dy,h] = dir(obj)
			% TODO test orthogonality
			X=mid(obj.X,2);
			Y=mid(obj.Y,2);
			dx = diff(X,1);
			dy = diff(Y,1);
			h=hypot(dx,dy);
			dx=dx./h;
			dy=dy./h;
		end

		function [ux,uy] = vel_sn2xy(obj,us,un,s)
			if (nargin() < 4)
				s = 1;
			end
			[dx,dy] = obj.dir();
			ux      =  bsxfun(@times,dx,us) + s*bsxfun(@times,dy,un);
			uy      = -s*bsxfun(@times,dy,us) + bsxfun(@times,dx,un);
		end
		function [us,un] = vel_xy2sn(obj,ux,uy)
			[us,un] = obj.vel_sn2xy(ux,uy,-1);
		end

		function edge = edge(obj)
			id = obj.id;
			id =reshape(id,obj.n);
			eid1 = [flat(id(:,1:end-1));
				flat(id(1:end-1,:)')];
			eid2 = [flat(id(:,2:end));
				  flat(id(2:end,:)')];
			edge = [eid1,eid2];
		end
			
		function [Xc,Yc] = elem_centre(obj)
			Xc = mid(mid(obj.X,1),2);
			Yc = mid(mid(obj.Y,1),2);
		end

		function id = column(obj,k)
			n = obj.n;
			id = (1:n(1))' + (k-1)*n(1);
		end

		function id = row(obj,k)
			n = obj.n;
			id = k + n(1)*(0:n(2)-1)';
		end
	
		function id = id(obj)
			id = (1:prod(obj.n))';
		end
		function valid = valid(obj)
			% buffer
			valid = false(obj.n+2);
			valid(2:end-1,2:end-1) = isfinite(obj.X);
		end
		function id = left(obj)
			%if (nargin()<2)
			%	id = obj.id;
			%end
			valid = obj.valid;
			valid = valid(2:end-1,1:end-2);
			id    = obj.id;
			n     = obj.n;
			id(~valid(id)) = NaN;
			id    = id-n(1);
			%id(~valid(id)) = NaN;
		end
		function Left = Left(obj)
			if (~isempty(obj.Left_))
				Left = obj.Left_;
			else
				n = obj.n;
				[Left, bid] = obj.Neighbour(-n(1));
				obj.Left_ = Left;
				obj.no_Left = bid;
			end
		end
		function Right = Right(obj)
			if (~isempty(obj.Right_))
				Right = obj.Right_;
			else
				n = obj.n;
				[Right, bid] = obj.Neighbour(+n(1));
				obj.Right_ = Right;
				obj.no_Right = bid;
			end
		end
		function Up = Up(obj)
			if (~isempty(obj.Up_))
				Up = obj.Up_;
			else
				[Up, bid] = obj.Neighbour(-1);
				obj.Up_    = Up;
				obj.no_Up = bid;
			end
		end
		function Down = Down(obj)
			if (~isempty(obj.Down_))
				Down      = obj.Down_;
			else
				[Down, bid] = obj.Neighbour(+1);
				obj.Down_   = Down;
				obj.no_Down = bid;
			end
		end
		function [Neighbour, bid] = Neighbour(obj,delta)
				id   = (1:obj.nn)';
				buf1 = id;
				buf2 = id+delta;
				buf3 = ones(obj.nn,1);
				% determine neighbours outside the boundary
				n      = obj.n;
				buf1_c = mod(buf1,n(1)); % col
				buf2_c = mod(buf2,n(1));
				buf1_r = floor((buf1-1)/n(1)); % row
				buf2_r = floor((buf2-1)/n(1));
				bid       = buf2<1 | buf2 > obj.nn ...
					    | (buf1_c ~= buf2_c & buf1_r ~= buf2_r);
				buf2(bid) = id(bid);
				bid = bid | ~isfinite(obj.X(buf2));
				bid = id(bid);
				% bid       = find(~obj.hasneighbour(+delta));
				% linear extrapolate on the boundary
				buf2(bid) = bid;
				buf3(bid) = 2;
				buf1      = [buf1; bid];
				% if there is no neighbour on one side,
				% there is always a neighbour on the other side
				buf2      = [buf2; bid-delta];
				buf3      = [buf3; -1*ones(size(bid))];
				Neighbour = sparse(buf1, buf2, buf3, obj.nn, obj.nn);
		end

		function id = right(obj,id)
			if (nargin()<2)
				id = obj.id;
			end
			valid = obj.valid;
			valid = valid(2:end-1,3:end);
			n     = obj.n;
			id(~valid(id)) = NaN;
			id    = id+n(1);
		end
		function id = up(obj,id)
			if (nargin()<2)
				id = obj.id;
			end
			valid = obj.valid;
			valid = valid(1:end-2,2:end-1);
			%n     = obj.n;
			id(~valid(id)) = NaN;
			id    = id-1;
		end
		function id = down(obj,id)
			if (nargin()<2)
				id = obj.id;
			end
			valid = obj.valid;
			valid = valid(3:end,2:end-1);
			%n     = obj.n;
			id(~valid(id)) = NaN;
			id    = id+1;
		end

	function Si = Si(obj)
		n = obj.n;
		Si = repmat((1:n(1))',1,n(2));
	end
	function Ni = Ni(obj)
		n = obj.n;
		Ni = repmat((1:n(2)),n(1),1);
	end

	function [S,N] = S(obj)
		if (isempty(obj.S_))
		%X    = X(1:end-1,1:end-1);
		%Y    = Y(1:end-1,1:end-1);
		X = obj.X;
		Y = obj.Y;
	
		% hold the zeros
		X_ = X;
		Y_ = Y;
		for idx=2:size(X,1)
		 for jdx=1:size(X,2)
			if (~isfinite(X_(idx,jdx)) || ~isfinite(Y_(idx,jdx)))
			%	X_(idx,jdx) = X_(idx-1,jdx);
			%	Y_(idx,jdx) = Y_(idx-1,jdx);
			end
		end
		end
		S = cumsum([zeros(1,size(X,2)); hypot(diff(X_),diff(Y_))]);
		X_ = X;
		Y_ = Y;
		for idx=1:size(X,1)
		 for jdx=2:size(X,2)
			if (~isfinite(X_(idx,jdx)) || ~isfinite(Y_(idx,jdx)))
			%	X_(idx,jdx) = X_(idx,jdx-1);
			%	Y_(idx,jdx) = Y_(idx,jdx-1);
			end
		end
		end
		N = cumsum([zeros(size(X,1),1), hypot(diff(X_,[],2),diff(Y_,[],2))],2);
		obj.S_ = S;
		obj.N_ = N;
		else
			S = obj.S_;
			N = obj.N_;
		end
	end

	function [N,S] = N(obj)
		[S,N] = obj.S;
	end

		function [dx_dS, dy_dS, dx_dN, dy_dN] = xydir(obj)
			n = obj.n;
			Ds = spdiags(0.5*ones(n(1),1)*[-1,0,1],-1:1,n(1),n(1));
			Ds(1,:) = 0;   Ds(1,1:2) = [-1,1];
			Ds(end,:) = 0; Ds(end,end-1:end) = [-1,1];
			Dn = spdiags(0.5*ones(n(2),1)*[-1,0,1],-1:1,n(2),n(2));
			Dn(1,:) = 0; Dn(1,1:2) = [-1,1];
			Dn(end,:) = 0; Dn(end,end-1:end) = [-1,1];
			Ds  = kron(Ds,speye(n(2)));
			Dn  = kron(speye(n(1)),Dn);
	
			dx_dS = Ds*flat(obj.X);
			dy_dS = Ds*flat(obj.Y);
			dx_dN = Dn*flat(obj.X);
			dy_dN = Dn*flat(obj.Y);
		end

		function [Dx, Dy, L] = derivative_matrices(obj)
			[Dx, Dy, D2x, Dxy, D2y, L] = derivative_matrix_curvilinear_2(obj.X,obj.Y);
			obj.Dx_  = Dx;
			obj.Dy_  = Dy;
			obj.L_   = L;
			obj.D2x_ = D2x;
			obj.Dxy_ = Dxy;
			obj.D2y_ = D2y;
		end

		function Dx = Dx(obj)
			if (isempty(obj.Dx_))
				obj.derivative_matrices();
			end
			Dx = obj.Dx_;
		end
		function Dy = Dy(obj)
			if (isempty(obj.Dy_))
				obj.derivative_matrices();
			end
			Dy = obj.Dy_;
		end
		function D2x = D2x(obj)
			if (isempty(obj.D2x_))
				obj.derivative_matrices();
			end
			D2x = obj.D2x_;
		end
		function Dxy = Dxy(obj)
			if (isempty(obj.Dxy_))
				obj.derivative_matrices();
			end
			Dxy = obj.Dxy_;
		end
		function D2y = D2y(obj)
			if (isempty(obj.D2y_))
				obj.derivative_matrices();
			end
			D2y = obj.D2y_;
		end
		function L = L(obj)
			if (isempty(obj.L_))
				obj.derivative_matrices();
			end
			L = obj.L_;
		end

		% rotate velocities from euclidean xy to mesh SN coordinates
		function [df_dS, df_dN] = xy2sn(obj, df_dx, df_dy)
			[dx_dS, dy_dS, dx_dN, dy_dN] = obj.xydir();
			df_dS = (dx_dS.*df_dx + dy_dS.*df_dy);
			df_dN = (dx_dN.*df_dx + dy_dN.*df_dy);
		end
	
		function [hS,hN] = hSN(obj)
			hS = hypot(diff(obj.X,[],2),diff(obj.Y,[],2));
			hN = hypot(diff(obj.X,[],1),diff(obj.Y,[],1));
		end

	end % methods
end  % SMesh

