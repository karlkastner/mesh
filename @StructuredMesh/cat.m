% Mon 21 Oct 21:02:35 +08 2019
function cat(obj,obj2)
	%mesh=map.smesh.copy;
	X=obj.X;
	Y=obj.Y;
	Z=obj.Z;

	X2 = obj2.X;
	Y2 = obj2.Y;
	Z2 = obj2.Z;
%	Y2=-Y;
	dx=mean(X(1,:)-X2(end,:));
	dy=mean(Y(1,:)-Y2(end,:));
	X2=X2+dx;
	Y2=Y2+dy;
	X2(end,:) = [];
	Y2(end,:) = [];
	Z2(end,:) = [];
	obj.X    = [fliplr(X2);X];
	obj.Y    = [fliplr(Y2);Y];
	obj.Z    = [fliplr(Z2);Z];
	obj.extract_elements;
end
