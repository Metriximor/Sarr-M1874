extends Resource
class_name RevolverSlot

var mesh: MeshInstance3D
var status: Status

enum Status {
	UNSPENT,
	SPENT,
	EMPTY
}

func _init(mesh: MeshInstance3D, status: Status = Status.UNSPENT) -> void:
	self.mesh = mesh
	self.status = status
	
