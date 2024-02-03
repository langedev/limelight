class_name ActorPosition extends Node2D

const FACE_RIGHT = false
const FACE_LEFT = true

@export var move_time := 0.3
@export var sprite: ActorSprite

enum Move {STAY, LEFT, RIGHT}
enum Turn {STAY, LEFT, RIGHT}

var stage: Stage:
	set(new_stage): stage = new_stage
var _stage_position: Stage.StagePosition

func init_stage_pos():
	_stage_position = stage.get_stage_position()
	var new_position := stage.stage_to_local(_stage_position)
	global_position = new_position
	sprite.start_moving_smoothly(new_position, new_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_key_state := _get_move_key_input(delta)
	if move_key_state.x != Move.STAY or move_key_state.y != Turn.STAY:
		_move(move_key_state.x, move_key_state.y)

func _move(move: Move, turn: Turn) -> void:
	match turn:
		Turn.LEFT:
			sprite.flip(FACE_LEFT)
		Turn.RIGHT:
			sprite.flip(FACE_RIGHT)

	var wrapping := false
	match move:
		Move.LEFT:
			if (sprite.is_moving() and _stage_position.previous_movement()) or \
					(not sprite.is_moving()):
				wrapping = _stage_position.decrement_position()
				_update_position(wrapping, move)
		Move.RIGHT:
			if (sprite.is_moving() and not _stage_position.previous_movement()) or \
					(not sprite.is_moving()):
				wrapping = _stage_position.increment_position()
				_update_position(wrapping, move)

func _update_position(wrapping: bool, move: Move) -> void:
	global_position = stage.stage_to_local(_stage_position)
	if wrapping:
		match move:
			Move.LEFT:
				sprite.move_onstage_right(stage.get_onstage_right(), \
						stage.get_offstage_right())
			Move.RIGHT:
				sprite.move_offstage_right(stage.get_offstage_left(), \
						stage.get_offstage_right())
	else:
		sprite.start_moving_smoothly(global_position)

var _right_key_time := 0.0
var _left_key_time := 0.0
func _get_move_key_input(delta: float) -> Vector2i:
	if Input.is_action_pressed("move_right"):
		_left_key_time = 0
		_right_key_time += delta
	if Input.is_action_just_released("move_right"):
		_right_key_time = 0

	if Input.is_action_pressed("move_left"):
		_right_key_time = 0
		_left_key_time += delta
	if Input.is_action_just_released("move_left"):
		_left_key_time = 0

	var output := Vector2i(Move.STAY, Turn.STAY)

	if _right_key_time >= move_time:
		output.x = Move.RIGHT
		output.y = Turn.RIGHT
	elif _right_key_time != 0:
		output.y = Turn.RIGHT

	if _left_key_time >= move_time:
		output.x = Move.LEFT
		output.y = Turn.LEFT
	elif _left_key_time != 0:
		output.y = Turn.LEFT

	return output
