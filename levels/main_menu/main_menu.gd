extends Control

@export var level_start: PackedScene

func start_game():
	get_tree().change_scene_to_packed(level_start)
