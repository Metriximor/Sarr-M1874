extends Node3D
class_name SarrM1874

@export var revolver: Revolver

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cycle"):
		revolver.cycle()
	if Input.is_action_just_pressed("unload"):
		revolver.unload()
	if Input.is_action_just_pressed("load"):
		revolver.reload()
	

func shoot() -> void:
	revolver.shoot()

func can_shoot() -> bool:
	return revolver.has_loaded_bullet()
