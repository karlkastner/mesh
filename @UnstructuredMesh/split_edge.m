% Wed 26 Oct 09:56:36 CEST 2016
%% split an edge
function [obj] = split_edge(obj,edx)

	if (islogical(edx))
		edx = find(edx);
	end
	ne = length(edx);

	% midpoints
	Pc = obj.edge_midpoint(edx);

	% add midpoints
	np = obj.np;
	obj.add_vertex(Pc(:,1),Pc(:,2));

	% boundary edges have to be split
	edge = obj.edge(edx,:);
	fdx  = find(obj.edge2elem(edx,2) == 0);
	if (~isempty(fdx))
	for idx=rvec(fdx)
		bnd1 = [edge(idx,1),np+idx];
		bnd2 = [edge(idx,2),np+idx];
		% update old edge
%		bdx = obj.bnd == edx(fdx);
%		obj.
		obj.edge(edx(idx),:) = bnd1;
		obj.edge(end+1,:) = bnd2;
		obj.bnd(end+1) = obj.nedge;
	end
	end
	% lazy retriangulation
	obj.retriangulate();

%	pdx = obj.edge(edx,:);
%	Xc  = 0.5*(obj.X(pdx(:,1))+obj.X(pdx(:,2)));
%	Yc  = 0.5*(obj.Y(pdx(:,1))+obj.Y(pdx(:,2)));
%	opj.point(np+1:ne,1:2) = [Xc,Yc];
	% closure
	%error('Closure not yet implemented');
	% one edges split
	% two edges split
	% three edges split
	
	% update old elements
	% insert two new elements
	% closure

%	obj.edges_from_elements();	
end

