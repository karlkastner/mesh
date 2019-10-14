% Sa 13. Feb 19:08:02 CET 2016
% Karl Kastner, Berlin
%
% iteratively improve angles to remove obtuse triangles
%
function obj = imrpove_angle_local(obj,solver,sopt)
	bnd3    = [];

	if (nargin < 2 || isempty(solver))
		%solver = @nlcg;	
		solver = @cauchy2;
	end
	if (nargin < 3)
		sopt = [];	
	end

	% point to element relations
	[void void pte_C] = obj.point_to_elem();

	ptp_C = obj.vertex_connectivity();

	% determine obtuse triangles
	to = find(~obj.check_orthogonality());

	% for each obtuse triangle
	for jdx=1:length(to)
		% vertices of the obtuse triangle
		po = obj.elem(to(jdx),:);

		% check which of the angles is the obtuse one
		cosa          = obj.angle(to(jdx));
		[cosamin mdx] = min(cosa);
		po = po(mdx);

		% get neighbouring points (level 1)
		p1 = find(ptp_C(:,po));

		% get indices of elements associated with these points
		tdxg = [];
		for pdx=1:length(p1)
			tdxg = [tdxg; find(pte_C(p1(pdx),:))'];
		end
		tdxg = unique(tdxg);

		% get elements in point index form
		Tg   = obj.elem(tdxg,:);

		% global point indices
		[pdxg ig il] = unique(Tg);

		% coordinates of local points 
		Pl  = obj.point(pdxg,1:2);

		% shift locally, to improve numerical accuracy
		Pl  = bsxfun(@minus,Pl,obj.point(po,1:2));

		% elements as indices into local point coordinates
		Tl  = reshape(il,[],3); %pdxl(il);

		% indices of inner points
		fdx = ismember(pdxg,p1); 
		% double stack for x and y coordinate
		fdx2 = [fdx;fdx];

		fun = @(P) MMesh.objective_angle(P,Tl,bnd3);
		[Popt f g] = solver(fun,Pl(:),sopt,fdx2);

		% unstack xy
		Popt = reshape(Popt,[],2);

		%shift back
		Popt  = bsxfun(@plus,Popt,obj.point(po,1:2));

		% write back coordinates
		obj.point(pdxg(fdx),1:2) = Popt(fdx,:);
	end % for jdx
	% break if there is no progress
end % improve_angle_local

