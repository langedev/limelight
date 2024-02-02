class_name Stage extends Node2D

@export var position_divisions := 5
@export var actor_scene: PackedScene
@export var tilemap: TileMap

enum StageDir {LEFT = -1, NULL = 0, RIGHT = 1}

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

func stage_to_local(pos: int) -> Vector2:
	return tilemap.map_to_local(Vector2(posmod(pos, position_divisions+2)-1,0))

func local_to_stage(local: Vector2) -> int:
	return posmod(tilemap.local_to_map(local).x+1, position_divisions+2)
