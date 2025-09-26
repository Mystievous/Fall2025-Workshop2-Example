extends CanvasLayer

@export var player: Player

# Stores the integer value that is displayed in the label.
var displayed_health: int = 0

# A variable to store the tween object.
# If the player gets hurt again, we interrupt the previous tween.
var health_tween: Tween

func _ready() -> void:
	refresh_health()
	
	# Connect the refresh_health() function to whatever player is inputted into the @export
	player.health_changed.connect(refresh_health)

func refresh_health():
	# Reset to a new tween object if one already existed.
	if health_tween:
		health_tween.kill()
	health_tween = create_tween()
	
	# Tween the displayed health value using the `set_label(value)` function.
	# This will smoothly interpolate between the values until it reaches the target or we interrupt it.
	health_tween.tween_method(set_label, displayed_health, player.health, 0.25)

func set_label(value: int):
	# Set the stored value and update the label text.
	displayed_health = value
	%Value.text = str(value)
