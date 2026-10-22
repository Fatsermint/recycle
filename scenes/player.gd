extends CharacterBody3D


var SPEED = 4
const JUMP_VELOCITY = 1.5
const SENSITIVITY = 0.005
@onready var camera: Camera3D = $head/Camera3D
@onready var head: Node3D = $head


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.position.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 0.5

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
	else:
		if direction:
			velocity.x = direction.x * SPEED *0.3
			velocity.z = direction.z * SPEED * 0.3
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED *0.3)
			velocity.z = move_toward(velocity.z, 0, SPEED *0.3)
		

	move_and_slide()
