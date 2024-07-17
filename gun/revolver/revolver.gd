extends MeshInstance3D
class_name Revolver

# Exported variables
@export var unspent_bullet: Mesh
@export var spent_bullet: Mesh
@export var animationPlayer: AnimationPlayer
@export var cycle_anim_name: String = "cycle"
@export var unload_anim_name: String = "unload"
@export var revolver_bullets: Array[MeshInstance3D] = []
@export var cycle_fx: AudioStreamPlayer3D

# Fixed Variables that are initialized by script
var revolver_slots: Array[RevolverSlot]
var reload_slot := 3

# Mutable state
var current_slot := 0:
	set(value):
		current_slot = value % revolver_bullets.size()
var current_reload_slot := reload_slot:
	get:
		return (reload_slot - current_slot) % revolver_bullets.size()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for bullet in revolver_bullets:
		bullet.mesh = unspent_bullet
		revolver_slots.append(RevolverSlot.new(bullet))


func has_loaded_bullet() -> bool:
	return revolver_slots[current_slot].status == RevolverSlot.Status.UNSPENT


func shoot() -> void:
	revolver_slots[current_slot].status = RevolverSlot.Status.SPENT
	

func cycle() -> void:
	animationPlayer.play("cycle_%s" % current_slot)
	cycle_fx.play()
	current_slot += 1


func reload() -> void:
	if revolver_slots[current_reload_slot].status != RevolverSlot.Status.EMPTY:
		return
	revolver_slots[current_reload_slot].status = RevolverSlot.Status.UNSPENT
	revolver_bullets[current_reload_slot].show()


func unload() -> void:
	if revolver_slots[current_reload_slot].status == RevolverSlot.Status.EMPTY:
		return
	#animationPlayer.play("unload_%s" % current_reload_slot)
	revolver_slots[current_reload_slot].status = RevolverSlot.Status.EMPTY
	revolver_bullets[current_reload_slot].hide()
