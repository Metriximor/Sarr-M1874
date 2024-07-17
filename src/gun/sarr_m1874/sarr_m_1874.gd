extends Node3D
class_name SarrM1874

@export var unspent_bullet: Mesh
@export var animationPlayer: AnimationPlayer
@export var revolver_slots: Array[RevolverSlot] = []
@export var cycle_fx: AudioStreamPlayer3D
@export var blank_bullet_fx: AudioStreamPlayer3D 
@export var reload_slot := 3

# Mutable state
var current_slot := 0:
	set(value):
		current_slot = value % revolver_slots.size()


# Accessor Fields
var current_barrel_slot : RevolverSlot:
	get:
		return revolver_slots[current_slot]
var current_reload_barrel_slot: RevolverSlot:
	get:
		return revolver_slots[(reload_slot - current_slot) % revolver_slots.size()]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for bullet in revolver_slots:
		bullet.mesh = unspent_bullet


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cycle"):
		cycle()
	if Input.is_action_just_pressed("unload"):
		unload()
	if Input.is_action_just_pressed("load"):
		reload()


func cycle() -> void:
	animationPlayer.play("cycle_%s" % current_slot)
	cycle_fx.play()
	current_slot += 1


func reload() -> void:
	if not current_reload_barrel_slot.isEmpty():
		return
	current_reload_barrel_slot.status = RevolverSlot.Status.UNSPENT
	current_reload_barrel_slot.show()


func unload() -> void:
	if current_reload_barrel_slot.status == RevolverSlot.Status.EMPTY:
		return
	#animationPlayer.play("unload_%s" % current_reload_slot)
	current_reload_barrel_slot.status = RevolverSlot.Status.EMPTY
	current_reload_barrel_slot.hide()


func pulling_trigger_is_going_to_fire() -> bool:
	if current_barrel_slot.isSpent():
		blank_bullet_fx.play()
		return false
	return true


func shoot() -> void:
	current_barrel_slot.status = RevolverSlot.Status.SPENT
