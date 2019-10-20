% 2016-08-08 16:15:02.579869097 +0200 plotcs.m
%% plot cross section
function plotcs(mesh,pdx,edx)
	path = pdx;
	%path = modelq(id).path;
	%edx  = modelq(id).elem;
			%plot(mesh.elemX(edx),mesh.elemY(edx),'g.-')
			for kdx=1:size(edx,1)
				X = [nanmean(mesh.elemX(edx(kdx,1))) nanmean(mesh.elemX(edx(kdx,2)))];
				Y = [nanmean(mesh.elemY(edx(kdx,1))) nanmean(mesh.elemY(edx(kdx,2)))];
%			for kdx=1:size(X,1)
%				plot(nanmean(X(kdx,:)),nanmean(Y(kdx,:)),'g.-')
%			end
				plot(X,Y,'g.-');
			end
			plot(mesh.X(path),mesh.Y(path),'r.-');
end

