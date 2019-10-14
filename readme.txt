unknown parameters:
	- 2 per interior vertex   (x and y coordinate)
	- 1 for boundary vertices if gradient is projected

Level 1 objectives:
	- fetch element coodinates from mesh structure,
	  call level 2 objectives, construct gradients

objective_A:
	- one column in objective function value vector per angle (3*nt)
	- always sufficiently number of columns
	- compatible with
		- cosa, angle and their scaled variants
		- oppist midpoint and height
objective_T:
	- one column in objective function value vector per element (1*nt)
	- always fewer columns than unknowns
	- compatible with in-ex
objective_P:
	- one column in objective function value vector per point (1xnp)
	- always halv as many columns than unknowns

Level 2: objectives
	- compute objective function value and gradient

