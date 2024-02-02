class_name Actor extends Node2D

@export var positionNode: ActorPosition

func set_tilemap(tilemap: TileMap):
	positionNode.tilemap = tilemap
	positionNode.force_move(Vector2(-1,0))
