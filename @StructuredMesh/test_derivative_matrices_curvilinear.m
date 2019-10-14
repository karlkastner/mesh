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

