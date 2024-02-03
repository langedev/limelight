class_name ActorSprite extends Sprite2D

@export var _default_flip := false
@export var _speed := 200
@export var _bobbing_rate := 200
@export var _bobbing_height := 20

var _is_moving := false
var _target: Vector2
var _moving_offstage_r := false
var _offstage_l: Vector2

func set_start_pos(pos: Vector2) -> void:
	global_position = pos
	_peak = global_position.y + _bobbing_height

func _move_toward(from: float, to: float, speed: float) -> float:
	var delta := to - from
	if abs(delta) < 0.00001 or abs(delta) < speed:
		return to
	else:
		return from + signf(delta)*speed

func _process(delta: float) -> void:
	if _is_moving:
		# Bobbing
		_bob(delta)

		# Move x coordinate
		_move_horizontal(delta)

func _move_horizontal(delta: float) -> void:
	global_position.x = _move_toward(global_position.x, _target.x, \
			delta*_speed)
	_is_moving = global_position.x != _target.x
	# TP to offstage left if done moving and called from move_offstage_right
	if _moving_offstage_r and not _is_moving:
		global_position = _offstage_l
		_moving_offstage_r = false

var _peak: float
var _bobbing_up := true
func _bob(delta: float) -> void:
	if _bobbing_up:
		global_position.y = _move_toward(global_position.y, _peak, \
				delta*_bobbing_rate)
		if global_position.y == _peak:
			_bobbing_up = false
	else:
		global_position.y = _move_toward(global_position.y, \
				_peak - _bobbing_height, delta*_bobbing_rate)
		if global_position.y == (_peak - _bobbing_height):
			_bobbing_up = true


func flip(face_right: bool):
	if face_right:
		set_flip_h(_default_flip)
	else:
		set_flip_h(not _default_flip)

func start_moving_smoothly(to: Vector2, from := global_position) -> void:
	global_position.x = from.x
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
