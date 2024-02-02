class_name Actor extends Node2D

@export var positionNode: ActorPosition

func set_stage(stage: Stage):
	positionNode.stage = stage
	positionNode.force_move(0)
