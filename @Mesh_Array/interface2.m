% Fr 29. Jan 15:07:52 CET 2016
% Karl Kastner, Berlin
%
% interface between mesh segments
function obj = interface2(obj,mesh)
	% for each triangle
	% if neighbour belongs to a different segment, points are on the interface
	N     = mesh.tneighbour();
	nflag = false(obj.length,obj.length);
	sdx   = obj.tsdx;
	i_C   = cell(obj.length,obj.length);
	% TODO, store local indices into elem
	for idx=1:mesh.nelem
		for jdx=1:3
			if (N(idx,jdx) > 0)
			if (sdx(idx) ~= sdx(N(idx,jdx)))
				% put global indices of interface points
				tdxl1 = obj.tdx_g2l(idx);
				tdxl2 = obj.tdx_g2l(N(idx,jdx));
				ia = zeros(2,2);
                                ia(1,1) = obj.mesh_A(sdx(idx)).elem(tdxl1,mod(jdx,3)+1);
                                ia(2,1) = obj.mesh_A(sdx(idx)).elem(tdxl1,mod(jdx+1,3)+1);
				% find corresponding nodes in facing triangle
				% TODO store facing side index
				for kdx=1:3
					if (mesh.elem(idx,mod(jdx,3)+1) == mesh.elem(N(idx,jdx),kdx))
						ia(1,2) = obj.mesh_A(sdx(N(idx,jdx))).elem(tdxl2,kdx);
					end
					if (mesh.elem(idx,mod(jdx+1,3)+1) == mesh.elem(N(idx,jdx),kdx))
						ia(2,2) = obj.mesh_A(sdx(N(idx,jdx))).elem(tdxl2,kdx);
					end
				end
				i_C{sdx(idx),sdx(N(idx,jdx))} = ...
                                           [i_C{sdx(idx),sdx(N(idx,jdx))}; ia];
                                %                 mesh.elem(idx,mod(jdx,3)+1), ...
                                %                 mesh.elem(idx,mod(jdx+1,3)+1)];
				% connect segments
				nflag(sdx(idx),sdx(N(idx,jdx))) = true;
			end % if (sdx(idx)) ~= sdx(N(idx,jdx))
			end % N(idx,jdx) > 0
		end % for jdx
	end % for idx
	% assign to sub-meshes
	for idx=1:obj.length
		obj.mesh_A(idx).sneighbour = find(nflag(idx,:));
		obj.mesh_A(idx).pinterface = {i_C{idx,:}};
	end % for idx
	if (Debug.LEVEL > Inf)
	for idx=1:obj.length
			figure(idx);
			clf();
			% plot meshes
			obj.mesh_A(idx).plot();
			hold on
			for jdx=obj.mesh_A(idx).sneighbour
				obj.mesh_A(jdx).plot();
				hold on
			end
			% plot interface points
			for jdx=obj.mesh_A(idx).sneighbour
				ia = obj.mesh_A(idx).pinterface{jdx};
				plot(obj.mesh_A(idx).point(ia(:,1),1),obj.mesh_A(idx).point(ia(:,1),2),'r.');
				plot(obj.mesh_A(jdx).point(ia(:,2),1),obj.mesh_A(jdx).point(ia(:,2),2),'ro');
			end
	end % for idx
	pause
	end%if Debug
end % interface 2

