% Wed 28 Nov 09:45:54 CET 2018
%% cubically smooth the mesh coordinates
function smooth_cubic(obj,opt,project)
	if (nargin()<2)
		opt = struct;
	end
	if (~isfield(opt,'relax'))
		p = 0.5;
	else
		p = opt.relax;
	end
	if (~isfield(opt,'maxiter'))
		opt.maxiter = 10;
	end

	order = 3;

	% cubic smoothing kernel
	switch (order)
	case {1}
		c = [1,1]/2;
	case {3}
		%c = [-1,9,0,9,-1]'/16;
		%c = [-1, 4, 2, 4, -1]/8;
		%c = [-2, 13, 21, 23, -7]/48;
		c = [-9, 36, 42, 36, -9]/96;
		% hermite: this is even less sharp
		% c = [1,3,3,1]/8;
	case {5}
		c = [3,  -25,  150,  150,  -25,    3]/256;	
	case {7}
		c = [    -5/462,   27/704,   -25/192,  135/224, 135/224,  -25/192,    27/704,   -5/462];
	end

	XY = [flat(obj.X) flat(obj.Y)];

	% build matrices outside loop
	obj.Left();
	obj.Right();
	obj.Up();
	obj.Down();

%	figure(100);
%	clf();
%	obj.plot();
%	hold on
	dx  = zeros(obj.nn,1);
	dy  = zeros(obj.nn,1);
	one = ones(obj.nn,1);	
	for idx=1:opt.maxiter
		switch (order)
		case {1}
			XY1 =     c(1)*(obj.Left_*XY) ...
			        + c(2)*(obj.Right_*XY);
			XY2 =     c(1)*(obj.Up_*XY) ...
			        + c(2)*(obj.Down_*XY);
		case {3}
		% smooth along first dimension
		XYl = obj.Left_*XY;
		XYr = obj.Right_*XY;
		XY1 =     c(1)*(obj.Left_*XYl) ...
			+ c(2)*XYl ...
			+ c(3)*XY ...
		        + c(4)*XYr ...
			+ c(5)*(obj.Right_*XYr);
		
		% smooth along second dimension
		XYu = obj.Up_*XY;
		XYd = obj.Down_*XY;
		XY2 =   c(1)*(obj.Up_*XYu) ...
			+ c(2)*XYu ...
			+ c(3)*XY ...
		        + c(4)*XYd ...
			+ c(5)*(obj.Down_*XYd);
		case {5}
			% smooth along first dimension
			XYl = obj.Left_*XY;
			XYr = obj.Right_*XY;
			XY1 =     c(1)*(obj.Left_*(obj.Left_*XYl)) ...
				+ c(2)*(obj.Left_*XYl) ...
			        + c(3)*XYl ...
				+ c(4)*XYr ...
				+ c(5)*(obj.Right_*XYr) ...
				+ c(6)*(obj.Right_*(obj.Right_*XYr));
			% smooth along second dimension
			XYu = obj.Up_*XY;
			XYd = obj.Down_*XY;
			XY2 =     c(1)*(obj.Up_*(obj.Up_*XYu)) ...
				+ c(2)*(obj.Up_*XYu) ...
			        + c(3)*XYu ...
				+ c(4)*XYd ...
				+ c(5)*(obj.Down_*XYd) ...
				+ c(6)*(obj.Down_*(obj.Down_*XYd));
		case {7}
			% smooth along first dimension
			XYl = obj.Left_*XY;
			XYr = obj.Right_*XY;
			XY1 =     c(1)*(obj.Left_*(obj.Left_*(obj.Left_*XYl))) ...
			        + c(2)*(obj.Left_*(obj.Left_*XYl)) ...
				+ c(3)*(obj.Left_*XYl) ...
			        + c(4)*XYl ...
				+ c(5)*XYr ...
				+ c(6)*(obj.Right_*XYr) ...
				+ c(7)*(obj.Right_*(obj.Right_*XYr)) ...
				+ c(8)*(obj.Right_*(obj.Right_*(obj.Right_*XYr)));
			% smooth along second dimension
			XYu = obj.Up_*XY;
			XYd = obj.Down_*XY;
			XY2 =     c(1)*(obj.Up_*(obj.Up_*(obj.Up_*XYu))) ...
			        + c(2)*(obj.Up_*(obj.Up_*XYu)) ...
				+ c(3)*(obj.Up_*XYu) ...
			        + c(4)*XYu ...
				+ c(5)*XYd ...
				+ c(6)*(obj.Down_*XYd) ...
				+ c(7)*(obj.Down_*(obj.Down_*XYd)) ...
				+ c(8)*(obj.Down_*(obj.Down_*(obj.Down_*XYd)));
		end
	%	figure()
	%	plot(obj.X,obj.Y,'k.');
	%	hold on
	%	plot(obj.X(obj.no_Left),obj.Y(obj.no_Left),'r.');
	%	plot(obj.X(obj.no_Right),obj.Y(obj.no_Right),'g.');
	%	plot(obj.X(obj.no_Up),obj.Y(obj.no_Up),'b.');
	%	plot(obj.X(obj.no_Down),obj.Y(obj.no_Down),'m.');
	%	axis equal

		% restore boundary
		XY1(obj.no_Left,:)  = XY(obj.no_Left,:); 
		XY1(obj.no_Right,:) = XY(obj.no_Right,:); 

		% restore boundary
		XY2(obj.no_Down,:) = XY(obj.no_Down,:); 
		XY2(obj.no_Up,:) = XY(obj.no_Up,:); 

		% smoothing step		
		dXY = 0.5*(XY1 + XY2) - XY;

		switch(project)
		case {1}
		% project to boundary
		[bnd_dx,bnd_dy,bnd_id,iscorner] = obj.boundary_direction();
		dx(bnd_id(:,1)) = bnd_dx;
		dy(bnd_id(:,1)) = bnd_dy;
		dx(bnd_id(iscorner,1)) = 0;
		dy(bnd_id(iscorner,1)) = 0;
		one(bnd_id(:,1)) = 0;
	
		% projection matrix for dx and dy at boundary points
		P = [diag(sparse(dx.*dx)),diag(sparse(dx.*dy));
		     diag(sparse(dx.*dy)),diag(sparse(dy.*dy))];
		P = P + [diag(sparse(one)),spzeros(obj.nn);
			 spzeros(obj.nn),diag(sparse(one))];
	
		dXY = reshape(P*dXY(:),[],2);
		case {2}
		%[bnd,iscorner] = obj.boundary_chain();
		%dXY(bnd(:),:) = 0;
		[bnd_dx,bnd_dy,bnd_id,iscorner] = obj.boundary_direction();
		dXY(bnd_id(:,1),:) = 0;
		%'done'
		end

		% update
		XY = XY + p*dXY;
		
		% write back inside loop because of bnd
		obj.X = reshape(XY(:,1),obj.n);
		obj.Y = reshape(XY(:,2),obj.n);	
	%	plot(flat(obj.X),flat(obj.Y),'.');
	%	axis equal
	%	axis([3.417557909032747   3.422308389610137  -0.357417229768531  -0.351721436005134]*1e5);
	end % for idx
	%	sum(c)
	%	pause
	% write back
	%obj.X = reshape(XY(:,1),obj.n);
	%obj.Y = reshape(XY(:,2),obj.n);
end % smooth_cubic

