extends MeshInstance3D
class_name RevolverSlot

var status: Status

enum Status {
	UNSPENT,
	SPENT,
	EMPTY
}

func _init(status: Status = Status.UNSPENT) -> void:
	self.status = status
	

func isEmpty() -> bool:
	return status == Status.EMPTY
	

func isSpent() -> bool:
	return status == Status.SPENT
