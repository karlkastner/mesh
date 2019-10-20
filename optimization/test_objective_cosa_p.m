% Mon  5 Dec 15:56:04 CET 2016

syms x1 x2 x3 y1 y2 y3
X = rand(1,3)
Y = rand(1,3)
%X     = [0 1 0]
%Y     = [0 0 1]
%X     = [x1 x2 x3] %rand(1,3)
%Y     = [y1 y2 y3] %rand(1,3)
if (~issym(X))
A = Geometry.tri_area(X,Y);
if (A<0)
	X = fliplr(X);
	Y = fliplr(Y);
end
end
p     = 2;
cosa0 = 1;

[f g H] = objective_cosa_p(X,Y,cosa0,p)
%g=grad(@(XY) objective_cosa_p(XY(1:3)',XY(4:6)',cosa0,p),[X';Y'])
[Hn gn] = hessian(@(XY) objective_cosa_p(XY(1:3)',XY(4:6)',cosa0,p),[X';Y']);
gn = gn'
Hn=Hn(tril(true(size(Hn))))'

corr(g',gn')
corr(H',Hn')

