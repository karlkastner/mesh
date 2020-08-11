% 2018-03-16 18:32:18.397742554 +0800

	% test centreline
	n = 100;
	L = 60;

if (1)
	t = linspace(0,L,n).';
	x = t;
	y = L/6*sin(2*pi*x/L);
else
	% straight mesh
	x = linspace(0,L,n).';
	y = zeros(n,1);
end
	w = 0.5*L/6*ones(n,1);
	ds = (L/n);
	nn = 0.1*round(L/ds)
		
	mesh = StructuredMesh();
	mesh.generate_from_centreline(x,y,w,ds,nn);
%	X=mesh.X;
%	figure(1);
%	clf
%	opt.edgecolor = 'r'; 
%	mesh.plot();
	%	mesh.smooth_simple([],[],0.5,1e3,5,1);
	%	axis([2.1351    2.3428    0.8773    1.1472]);	
	%	pause(1)
	%norm(X-pf.mesh.X)
%	hold on
%	mesh.plot([],opt);

	syms x y;
	s.f = (x/L-1/2).^3 + (6*y/L).^3 + (x/L-1/2).^3.*(6*y/L).^3; 
	fun.f    = matlabFunction(s.f);
	fun.dfdx = matlabFunction(diff(s.f,x));
	fun.dfdy = matlabFunction(diff(s.f,y));
	fun.d2fdx2 = matlabFunction(diff(s.f,x,2));
	fun.d2fdxdy = matlabFunction(diff(diff(s.f,x),y));
	fun.d2fdy2 = matlabFunction(diff(s.f,y,2));

	f    = flat(fun.f(mesh.X,mesh.Y));
	[max(f(:)),min(f(:))]
	df   = [flat(fun.dfdx(mesh.X,mesh.Y)),flat(fun.dfdy(mesh.X,mesh.Y))];
	d2f   = [flat(fun.d2fdx2(mesh.X,mesh.Y)), ...
		 flat(fun.d2fdxdy(mesh.X,mesh.Y)), ...
		 flat(fun.d2fdy2(mesh.X,mesh.Y))];
	df_  = [mesh.Dx*f,mesh.Dy*f];
	d2f_  = [mesh.D2x*f,mesh.Dxy*f,mesh.D2y*f];

if (0)
figure(2);
clf();
	res = df_-df;
	rms(res)
	res_ = res./(abs(df(:,idx))+mean(abs(df(:,idx))));
	for idx=1:2
	subplot(2,3,1+3*(idx-1))
%	mesh.plot(
	scatter3(mesh.X,mesh.Y,res_(:,idx));
	colorbar
	subplot(2,3,2+3*(idx-1))
	mesh.plot(df(:,idx));
	colorbar
	title('exact')
	subplot(2,3,3+3*(idx-1))
	mesh.plot(df_(:,idx));
	colorbar
	title('Dx')
	end
end

if (1)
figure(3);
clf();
	res = d2f_-d2f;
	rms(res)
	res_ = res./(abs(d2f(:,idx))+mean(abs(d2f(:,idx))));
	for idx=1:3
	subplot(3,3,1+3*(idx-1))
	%mesh.plot(abs(res(:,idx))./(abs(d2f(:,idx))+mean(abs(d2f(:,idx)))));
	scatter3(flat(mesh.X),flat(mesh.Y),res_(:,idx),[],res_(:,idx));
	view(0,90);
	colorbar
	subplot(3,3,2+3*(idx-1))
	mesh.plot(d2f(:,idx));
	colorbar
	title('exact')
	subplot(3,3,3+3*(idx-1))
	mesh.plot(d2f_(:,idx));
	colorbar
	title('Dx')
	end
end
	
	

%	figure(1);
%	clf();
%	mesh.plot();
%function [Dx,Dy,D2x,Dxy,D2y,L] = derivative_matrix_curvilinear_2(x,y,isorthogonal)

if (0)

	figure(2);
	subplot(2,2,1)
	imagesc(reshape(ds_dx,n));
	subplot(2,2,2)
	imagesc(reshape(ds_dy,n));
	subplot(2,2,3)
	imagesc(reshape(dn_dx,n));
	subplot(2,2,4)
	imagesc(reshape(dn_dy,n));
	
	figure(3)
	subplot(2,2,1)
	imagesc(reshape(dx_ds,n));
	subplot(2,2,2)
	imagesc(reshape(dy_ds,n));
	subplot(2,2,3)
	imagesc(reshape(dx_dn,n));
	subplot(2,2,4)
	imagesc(reshape(dy_dn,n));
end
