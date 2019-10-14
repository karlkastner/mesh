% same as logspace(log10(x0),log10(xend),n)
function x = dzmesh(x0,xend,n)
	%note : the best mesh for a log profile is :
 	% u_i - u_i+1 = const
	% log(z_i+1) - log(z_i) = const
	% z_i+1/z_i = exp(c)
	% z_i+1 = z_i exp(c) = z_0 exp(c*i)
	c = (log(xend)-log(x0))/(n-1);
	x = x0*exp(c*(0:n-1));
end
