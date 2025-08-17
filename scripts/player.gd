extends CharacterBody3D

const SPEED: float = 7.0
const JUMP_VEL: float = 6.5

@export var player_id: int = 1:
	set(id):
		player_id = id
		$PlayerInput.set_multiplayer_authority(id)

var gravity = 15.0
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var input = $PlayerInput
@onready var camera: Camera3D = $CamMount/Camera3D

func _ready():
	if player_id == multiplayer.get_unique_id():
		camera.current = true
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent):
	var is_local = player_id == multiplayer.get_unique_id()
	var mouse_captured = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if is_local and mouse_captured and event is InputEventMouseMotion:
		camera.rotate_x(-event.relative.y * 0.0025)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _process(_delta: float):
	rotate_y(input.input_rot)
	input.input_rot = 0.0

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if input.jumping and is_on_floor():
		velocity.y = JUMP_VEL
	
	input.jumping = false
	
	var direction = (transform.basis * Vector3(input.input_dir.x, 0, input.input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
