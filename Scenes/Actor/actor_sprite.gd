class_name ActorSprite extends Sprite2D

@export var _default_flip := false
@export var _speed := 200
# @export var _bobbing_rate := 200
# @export var _bobbing_height := 20

var _is_moving := true
var _target: Vector2
var _moving_offstage_r := false
var _offstage_l: Vector2

# var _peak := Vector2.UP * _bobbing_height
# var _bob_dir := Vector2.UP
func _process(delta: float) -> void:
	if _is_moving:
		global_position = global_position.move_toward(_target, delta * _speed)
		_is_moving = global_position != _target
		# TP to offstage left if done moving and called from move_offstage_right
		if _moving_offstage_r and not _is_moving:
			global_position = _offstage_l
			_moving_offstage_r = false


func flip(face_right: bool):
	if face_right:
		set_flip_h(_default_flip)
	else:
		set_flip_h(not _default_flip)

func start_moving_smoothly(to: Vector2, from := global_position) -> void:
	global_position = from
	_target = to
	_is_moving = true
	_moving_offstage_r = false

func is_moving() -> bool:
	return _is_moving

func move_onstage_right(onstage_r: Vector2, offstage_r: Vector2) -> void:
	# TP to offstage right
	global_position = offstage_r
	# Move to onstage right
	start_moving_smoothly(onstage_r)

func move_offstage_right(offstage_l: Vector2, offstage_r: Vector2) -> void:
	# Move to offstage right
	start_moving_smoothly(offstage_r)
	_moving_offstage_r = true
	_offstage_l = offstage_l
	# TP to offstage left in _process
