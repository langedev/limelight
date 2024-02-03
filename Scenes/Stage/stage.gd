class_name Stage extends Node2D

@export var position_divisions := 5
@export var actor_scene: PackedScene
@export var tilemap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var screensize := get_viewport_rect().size
	tilemap.tile_set.tile_size = \
		Vector2(screensize.x / position_divisions, screensize.y)

	# TODO: Change how actor is added to scene
	add_child(actor_scene.instantiate())

func _on_child_entered_tree(node: Node):
	if node is Actor:
		node.set_stage(self)

func get_stage_position() -> StagePosition:
	return StagePosition.new(position_divisions+1)

func stage_to_local(pos: StagePosition) -> Vector2:
	return tilemap.map_to_local(Vector2(pos._get_position(),0))

func get_offstage_right() -> Vector2:
	return tilemap.map_to_local(Vector2(position_divisions,0))

func get_onstage_right() -> Vector2:
	return tilemap.map_to_local(Vector2(position_divisions-1,0))

func get_offstage_left() -> Vector2:
	return tilemap.map_to_local(Vector2(-1,0))

class StagePosition:
	# 0 is offstage, everything else is onstage
	var _position := 0
	var _prev_pos := false
	var _divisions: int

	func _init(divisions, position = 0):
		_divisions = divisions
		_position = position

	# External range is [-1, divisions-2]
	# Internal range is [0, divisions-1]
	# This is for compatibility with tilemap
	func _get_position() -> int:
		return _position - 1

	# Return true if the last movement call was increment_position otherwise
	# returns false
	func previous_movement() -> bool:
		return _prev_pos

	# Returns true if it wraps divisions-1 -> 0
	func increment_position() -> bool:
		_prev_pos = true
		_position = posmod(_position+1, _divisions)
		if _position == 0:
			return true
		return false

	# Returns true if it wraps 0 -> divisons-1
	func decrement_position() -> bool:
		_prev_pos = false
		_position = posmod(_position-1, _divisions)
		if _position == (_divisions-1):
			return true
		return false

	func force_position(position: int) -> void:
		_prev_pos = false
		_position = posmod(position, _divisions)
