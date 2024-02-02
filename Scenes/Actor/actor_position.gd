class_name ActorPosition extends Node2D

const FACE_RIGHT = false
const FACE_LEFT = true

@export var move_time := 0.3
@export var sprite: Sprite2D

enum KeyDirections {STAY, MOVE_RIGHT, MOVE_LEFT, TURN_RIGHT, TURN_LEFT}

var tilemap: TileMap:
	set(new_tilemap): tilemap = new_tilemap
var _prev_dir := Vector2.ZERO

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
			if (sprite.is_moving() and _prev_dir == Vector2.RIGHT) or \
					(not sprite.is_moving()):
				sprite.flip(FACE_LEFT)
				_move_tile(Vector2.LEFT)
		KeyDirections.MOVE_RIGHT:
			if (sprite.is_moving() and _prev_dir == Vector2.LEFT) or \
					(not sprite.is_moving()):
				sprite.flip(FACE_RIGHT)
				_move_tile(Vector2.RIGHT)
		KeyDirections.TURN_LEFT:
			sprite.flip(FACE_LEFT)
		KeyDirections.TURN_RIGHT:
			sprite.flip(FACE_RIGHT)

func force_move(tilemap_position: Vector2) -> void:
	var new_position := tilemap.map_to_local(tilemap_position)
	global_position = new_position
	sprite.start_moving_smoothly(new_position, new_position)

func _move_tile(direction: Vector2) -> void:
	_prev_dir = direction.normalized()
	var current_tile: Vector2i = tilemap.local_to_map(global_position)
	var target_tile: Vector2i = Vector2(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)

	global_position = tilemap.map_to_local(target_tile)
	if sprite.is_moving():
		sprite.start_moving_smoothly(tilemap.map_to_local(target_tile))
	else:
		sprite.start_moving_smoothly(tilemap.map_to_local(target_tile), \
			tilemap.map_to_local(current_tile))
