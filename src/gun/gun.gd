extends Node3D
class_name Gun

@export var knockback: AnimationPlayer
@export var barrel_raycast: RayCast3D
@export var sight_raycast: RayCast3D
@export_range(5, 360) var aiming_down_sight_fov := 25.0
@export var bullet_scene: PackedScene
@export var bullet_speed := 550
@export var gunshot_audio: AudioStreamPlayer3D
@export var gun_model: SarrM1874 # change the type to be generic gun 

@onready var default_pos: Vector3 = self.transform.origin

func shoot(shoot_location: Vector3) -> void:
	if knockback.is_playing():
		return
		
	if not gun_model.pulling_trigger_is_going_to_fire():
		return
	
	knockback.play("shoot")
	gun_model.shoot()
	gunshot_audio.play()
	
	# Bullet spawning
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = barrel_raycast.global_position
	bullet.transform = barrel_raycast.global_transform
	bullet.apply_central_impulse(shoot_location * bullet_speed)
	owner.add_child(bullet)
