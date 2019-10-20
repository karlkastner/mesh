% 2016-11-09 17:03:36.997332232 +0100
% Karl Kastner, Berlin
%
%% improve mesh topology
%
function obj = improve_topology(obj,verbose,show)
	if (3 ~= size(obj.elem,2))
		error('Only implemented for triangulations');
	end
	if (nargin()<2)
		verbose = 0;
	end
	if (nargin()<3)
		show = false;
	end
	if (show)
		objc = obj.copy();
	end

	change = true;
	nchange = 0;
	nn0 =NaN;
	f0 = NaN;
	while (change)
		change = false;
		% determine vertices with more than 7 neighbours
		% TODO more efficient with a tree/hash
		[v2v nv2v] = obj.vertex_to_vertex();
		nn         = full(sum(v2v))';
		v2t        = obj.vertex_to_element();
		v2edge     = obj.vertex_to_edge();
		f0(nchange+1) = sum((nn-nn0).^2);
		f0(end)

		% optimum angle and optimum number of neighbours
		[cosa0 alpha0 nn0] = obj.optimum_angle();

%		fdx = find(nn<5 | nn>7);
		fdx = find( abs(nn-nn0)>1 );
		% for each irregular vertex
		for vdx=rvec(fdx)
			if (nn(vdx)<nn0(vdx)-1)
				% if vertex is connected to less than five neighbours,
				% flip any facing edge to increase its connectivity

				% determine adjacent triangles
				tdx = find(v2t(vdx,:))';

				% determine facing triangles
				tdx(:,2) = obj.facing_element(tdx,vdx);
			elseif (nn(vdx)>nn0(vdx)+1)
				% if vertex is connected to more than seven neighbours,
				% flip any of the adjacent edges to decrease its connectivity
				e = find(v2edge(vdx,:));
				% get the two elements facing at the edge (flip candidates)
				tdx = obj.edge2elem(e,:);
			else
				% this point was indiredctly regularised
				continue;
			end

			% determine mesh quality if edge were flipped
			[dfobj dftopo] = obj.flip_quality(tdx,nv2v,nn0);

			abstol = -sqrt(eps);
			nvalid   = sum(dftopo < abstol & isfinite(dftopo));
			if (nvalid > 0)

			% select the flips that are best for topology
			[dftopo sdx] = sort(dftopo);
			dftopo(1)

			%fdx   = (dftopo <= dftopo(1)+eps);
			fdx   = dftopo < abstol;
			sdx   = sdx(fdx);
			tdx   = tdx(sdx,:);
			dfobj = dfobj(sdx);

%			dfobj  = dfobj(fdx);
%			tdx    = tdx(fdx,:);
%			dftopo = dfobj(fdx);

			% if tie, determine flip that deteriorates the mesh objective least
			[dfobj mdx] = min(dfobj);

%			clf
%			opt = struct
%			opt.surface = false;
%			opt.edges = true;
%			objc.plot([],opt);
%			hold on
			

			elem = obj.elem;
			obj.flip(tdx(mdx,1),tdx(mdx,2));
			d=obj.elem-elem;
%			norm(d)
			change = true;
			nchange = nchange+1;
			if (verbose)
				fprintf('Improved %d verices\n');
			end
			disp([vdx nchange])
		
			% update connection matrices	
			obj.edges_from_elements();
			break;
			if (0)
			[v2v nv2v] = obj.vertex_to_vertex();
			nn         = full(sum(v2v));
			v2t        = obj.vertex_to_element();
			v2edge     = obj.vertex_to_edge();
			% optimum angle and optimum number of neighbours
			[cosa0 alpha0 nn0] = obj.optimum_angle();
			end

%			opt.edgearg={'Edgecolor','g'}
%			obj.plot([],opt);
%			drawnow
%			pause()

			end % if ~isempty(fdx)
		end % for idx
	end % while (1)

	fprintf(1,'Flipped %d edges to improve mesh topology\n',nchange);
	% TODO, number of improved locations
	if (length(fdx)>0)
		fprintf(1,'Cannot further improve the topology at %d vertices\n',length(fdx));
	else
		fprintf(1,'No further vertices with non-optimal topology remain.\n');
	end
	
	if (show)
		figure();
		%f = figure();
		%clf
		opt = struct
		opt.surface = false;
		opt.edges = true;
		opt.edgearg={'Edgecolor','k'}
		objc.plot([],opt);
		hold on
		opt.edgearg={'Edgecolor','g'}
		obj.plot([],opt);
	end
end % function	

