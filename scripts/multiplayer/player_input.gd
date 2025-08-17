extends MultiplayerSynchronizer

@export var jumping: bool = false
@export var input_dir: Vector2 = Vector2()
@export var input_rot: float = 0.0

func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		input_rot = event.relative.x * -0.0025

func _process(delta: float):
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if Input.is_action_just_pressed("jump"):
		jump.rpc()

@rpc("call_local")
func jump():
	jumping = true
