% 2016-11-09 11:32:47 +0100

function [dfobj dftopo] = flip_quality(obj,tdx,nv2v,nn0)
	fobj   = @objective_3_angle;
	alpha0 = deg2rad(60);
%	nn0 = 6;

	n     = size(tdx,1);
	dfobj  = NaN(n,1);
	dftopo = NaN(n,1);
	d0     = NaN(n,4);
	d1     = NaN(n,4);
	% 
	[f s] = obj.get_facing_and_shared_vertices(tdx);
	for idx=1:n
		if (f(idx,1) > 0)
		% TODO only if both triangles exist there are two triangles (not at edge)
		%if (all(tdx(idx,:)>0)
		% get function value difference for flipped and unflipped state
		dfobj(idx) =   max(fobj([f(idx,:) s(idx,1)], [f(idx,:),s(idx,2)],alpha0)) ... % after flip
			     - max(fobj([f(idx,1) s(idx,:)], [f(idx,2) s(idx,:)],alpha0)); ...

		% get topology change
		% absolute difference between optimum number of neighbours and actual number of neighbours
		% before flip
		d0(idx,:) = [abs(nv2v(f(idx,:))-nn0(f(idx,:))); abs(nv2v(s(idx,:))-nn0(s(idx,:)))];
		% after flip
		d1(idx,:) = [abs(nv2v(f(idx,:))+1-nn0(f(idx,:))); abs(nv2v(s(idx,:))-1-nn0(s(idx,:)))];

%		d1 = [abs(nv2v(f(idx,:))+1-nn0(f(idx,:))), abs(nv2v(s(idx,:))-1-nn0(s(idx,:)))]
		dftopo(idx) = sum(sum( abs(nv2v(f(idx,:))+1-nn0(f(idx,:))) + abs(nv2v(s(idx,:))-1-nn0(s(idx,:))) )) ... % after flip
			     -sum(sum( abs(nv2v(f(idx,:))-nn0(f(idx,:)))   + abs(nv2v(s(idx,:))-nn0(s(idx,:))) ));      % before flip


%		nn_ = [nn(f(idx,:))+1, nn(s(idx,:))-1];
		
		% 
		% get d
		% change of objective function value
		% change of topology
		end
	end
	% allow a difference of 1, otherwise there cannot be graded meshes
	dftopo = sum(max(0,d1-1),2)-sum(max(0,d0-1),2);
end

