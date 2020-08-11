% Wed 13 May 17:01:03 +08 2020
% set values on boundaries to : p*v + (1-p)*dv/dn  = val 
% xb yb : user specified coordinates of 
% function A  = apply_boundary_condition_hermite(obj,A,xb,yb,p,val)
%
% at the inhomogeneous boundaries: int du_dn v != 0
function A  = apply_boundary_condition_hermite(obj,A,xb,yb,p,val)
end % apply_boundary_condition_hermite

function f
		% evaluate derivatives at qu
			% for each end point on the boundary edge
			for kdx=1:2
				vid  = edge(fdx(jdx),kdx);
				dxid = edge(fdx(jdx),kdx) +   obj.np;
				dyid = edge(fdx(jdx),kdx) + 2*obj.np;
				t    = obj.edge_direction(fdx(jdx),:);
				% normal direction
				% TODO this requires the edge to be ordered, so that the inside and outside is properly determined (!)
				n(1) = -t(2);
				n(2) =  t(1);
				% set value + normal derivative to value
				A(vid,:)    = 0;
				A(vid,vid)  = p(idx);
				A(vid,dxid) = (1-p)*n(1);
				A(vid,dyid) = (1-p)*n(2);
				rhs(dxid)   = vale;
				% set tangential derivative to zero
				% TODO for outflow boundaries, actually the along edge-derivative of the normal-derivative should be zero
				A(dxid,:)    = 0;
				A(dxid,dxid) = t(1);
				A(dxid,dyid) = t(2);
				rhs(dxid)    = 0;
			end % kdx
		end % jdx
end
