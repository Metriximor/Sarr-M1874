extends CharacterBody3D

const ADS_LERP := 20

@export var speed := 5.0
@export_range(0.0, 2.0) var speed_mult := 1.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.002
@export var fps_camera: Camera3D
@export var held_gun: Gun

@onready var default_fov := self.fps_camera.fov

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	var actual_speed = speed
	if Input.is_action_pressed("sprint"):
		actual_speed *= (1.0 + speed_mult)
	
	if Input.is_action_pressed("aim"):
		var iron_sights_position = -held_gun.sight_raycast.position
		iron_sights_position.z = held_gun.default_pos.z
		
		held_gun.transform.origin = held_gun.transform.origin.lerp(iron_sights_position, ADS_LERP * delta)
		fps_camera.fov = lerp(fps_camera.fov, held_gun.aiming_down_sight_fov, ADS_LERP * delta)
	else:
		held_gun.transform.origin = held_gun.transform.origin.lerp(held_gun.default_pos, ADS_LERP * delta)
		fps_camera.fov = lerp(fps_camera.fov, default_fov, ADS_LERP * delta)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * actual_speed
		velocity.z = direction.z * actual_speed
	else:
		velocity.x = move_toward(velocity.x, 0, actual_speed)
		velocity.z = move_toward(velocity.z, 0, actual_speed)

	move_and_slide()


func _input(event: InputEvent) -> void:
	# DEBUG: close game on escape
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("shoot"):
		held_gun.shoot(_get_center_of_viewport())
		
	if event is InputEventMouseMotion:
		_handle_mouse_input_motion(event)
		

func _handle_mouse_input_motion(event: InputEventMouseMotion) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		pass
		
	rotate_y(-event.relative.x * mouse_sensitivity)
	fps_camera.rotate_x(-event.relative.y * mouse_sensitivity)
	fps_camera.rotation.x = clampf(fps_camera.rotation.x, -deg_to_rad(90), deg_to_rad(90))


func _get_center_of_viewport() -> Vector3:
	var start = fps_camera.project_ray_origin(get_viewport().get_size()/2)
	var end = start + fps_camera.project_ray_normal(get_viewport().get_size()/2) * 2
	return (end - fps_camera.global_transform.origin).normalized()
