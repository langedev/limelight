extends Sprite2D

@export var _default_flip := false
@export var _speed := 200
# @export var _bobbing_rate := 200
# @export var _bobbing_height := 20

var _is_moving := true
var _target: Vector2

# var _peak := Vector2.UP * _bobbing_height
# var _bob_dir := Vector2.UP
func _process(delta: float) -> void:
	if _is_moving:
		global_position = global_position.move_toward(_target, delta * _speed)
		_is_moving = global_position != _target


func flip(face_right: bool):
	if face_right:
		set_flip_h(_default_flip)
	else:
		set_flip_h(not _default_flip)

func start_moving_smoothly(to: Vector2, from := global_position) -> void:
	global_position = from
	_target = to
	_is_moving = true

func is_moving() -> bool:
	return _is_moving
