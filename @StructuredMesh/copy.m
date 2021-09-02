% Mon 21 Oct 20:59:00 +08 2019
function obj2 = copy(obj)
	obj2 = StructuredMesh();
	obj2.X = obj.X;
	obj2.Y = obj.Y;
	obj2.Z = obj.Z;
	obj2.elem = obj.elem;
end
