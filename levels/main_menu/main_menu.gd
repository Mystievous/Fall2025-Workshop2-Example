extends Control

# The scene we want the button to go to
@export var level_start: PackedScene

# Through the `Node` tab, the `StartButton` clicked signal is assigned to this function
# If you click the green icon on the left of the function you can also see all the connected signals.
func start_game():
	# Unload the current scene and switch to the specified one
	get_tree().change_scene_to_packed(level_start)
