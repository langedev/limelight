class_name ActorPosition extends Node2D

const FACE_RIGHT = false
const FACE_LEFT = true

@export var move_time := 0.3
@export var sprite: Sprite2D

enum KeyDirections {STAY, MOVE_RIGHT, MOVE_LEFT, TURN_RIGHT, TURN_LEFT}

var stage: Stage:
	set(new_stage): stage = new_stage
var _prev_dir: Stage.StageDir = Stage.StageDir.NULL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_key_state = _get_move_key_input(delta)
	_move(move_key_state)

var right_key_time := 0.0
var left_key_time := 0.0
func _get_move_key_input(delta: float) -> KeyDirections:
	if Input.is_action_pressed("move_right"):
		left_key_time = 0
		right_key_time += delta
	if Input.is_action_just_released("move_right"):
		right_key_time = 0

	if Input.is_action_pressed("move_left"):
		right_key_time = 0
		left_key_time += delta
	if Input.is_action_just_released("move_left"):
		left_key_time = 0

	if right_key_time >= move_time:
		return KeyDirections.MOVE_RIGHT
	if left_key_time >= move_time:
		return KeyDirections.MOVE_LEFT
	if right_key_time == 0:
		if left_key_time == 0:
			return KeyDirections.STAY
		return KeyDirections.TURN_LEFT
	return KeyDirections.TURN_RIGHT

func _move(key_state: KeyDirections) -> void:
	match key_state:
		KeyDirections.MOVE_LEFT:
			if (sprite.is_moving() and _prev_dir == Stage.StageDir.RIGHT) or \
					(not sprite.is_moving()):
				sprite.flip(FACE_LEFT)
				_move_tile(stage.StageDir.LEFT)
		KeyDirections.MOVE_RIGHT:
			if (sprite.is_moving() and _prev_dir == Stage.StageDir.LEFT) or \
					(not sprite.is_moving()):
				sprite.flip(FACE_RIGHT)
				_move_tile(stage.StageDir.RIGHT)
		KeyDirections.TURN_LEFT:
			sprite.flip(FACE_LEFT)
		KeyDirections.TURN_RIGHT:
			sprite.flip(FACE_RIGHT)

func force_move(stage_position: int) -> void:
	var new_position := stage.stage_to_local(stage_position)
	global_position = new_position
	sprite.start_moving_smoothly(new_position, new_position)

func _move_tile(direction: int) -> void:
	_prev_dir = direction / abs(direction)
	var current_pos: int = stage.local_to_stage(global_position)
	var target_pos: int = current_pos + direction

	prints(current_pos, target_pos)

	global_position = stage.stage_to_local(target_pos)
	if sprite.is_moving():
		sprite.start_moving_smoothly(stage.stage_to_local(target_pos))
	else:
		sprite.start_moving_smoothly(stage.stage_to_local(target_pos), \
			stage.stage_to_local(current_pos))
