extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VEL: float = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player_id: int = 1:
	set(id):
		player_id = id
		$PlayerInput.set_multiplayer_authority(id)

@onready var input = $PlayerInput
@onready var camera_3d: Camera3D = $CamMount/Camera3D

func _ready():
	if player_id == multiplayer.get_unique_id():
		camera_3d.current = true

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
