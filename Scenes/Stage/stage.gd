extends Node2D

@export var position_divisions := 5
@export var actor_scene: PackedScene
@export var tilemap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var screensize := get_viewport_rect().size
	tilemap.tile_set.tile_size = \
		Vector2(screensize.x / position_divisions, screensize.y)

	add_child(actor_scene.instantiate())

func _on_child_entered_tree(node: Node):
	if node is Actor:
		node.set_tilemap(tilemap)
