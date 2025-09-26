extends CharacterBody2D
class_name Player

# Derived from https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html#platformer-movement

@export_group('Combat')
@export var health: int = 30

@export_group('Movement')
@export var movement_speed: float = 400
@export var jump_speed: float = 500

# The (negative) default gravity value from the godot settings.
# This ensures that player gravity matches other elements like rigidbodies.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# We emit this any time the player is damaged.
signal health_changed

func _physics_process(delta: float) -> void:
	# Gets the left/right movement
	# 
	# These "ui_{direction}" inputs are set by default, but you can
	# also make new ones by going to Project > Project Settings > Input Map.
	# Then, just reference them the same way by name.
	var x_input = Input.get_axis("ui_left", "ui_right")
	
	# The `velocity` field is from the `CharacterBody2D`.
	# This is where we tell the node how fast (and where) it should be moving this physics frame.
	# This is automatically used by `move_and_slide()` later.
	velocity.x = x_input * movement_speed
	
	# Apply gravity
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("ui_up"):
		try_jump()
	
	# Tells the engine to use the set velocity
	# and move the character the proper amount,
	# interacting with any collision bodies along the way.
	move_and_slide()
	
# Check if the ground raycast is colliding with the ground
func isOnGround():
	# The raycast is referenced here with a "unique name"
	# You can do this by right clicking a node and hitting "Access as Unique Name".
	# Then, you can either manually type the name with a percentage sign in front, or
	# drag and drop the node directly into your code.
	#
	# This works best in self-contained scenes like this, where you always know exactly
	# what nodes you use.
	# 
	# However, you might want to avoid this for the most part, as if you ever change
	# the name of the node, you must also change every reference to the name independently.
	return %GroundRayCast.is_colliding()

func try_jump():
	# Check if the jump timer is running (on cooldown)
	var jump_is_ready: bool = %JumpTimeout.is_stopped()
	if jump_is_ready and isOnGround():
		velocity.y += -jump_speed
		%JumpTimeout.start()


func damage(amount: int):
	health -= amount
	health_changed.emit()
	if (health <= 0):
		# queue_free() just tells the engine to remove/destroy this object at the next chance.
		queue_free()
	
	# Set the color to hurt and start the timer
	%Sprite2D.modulate = Color(0.707, 0.124, 0.0)
	%HurtColorTimeout.start()

# Signal connected through the tab to the right *from* the HurtColorTimeout node.
func _on_hurt_color_timeout() -> void:
	%Sprite2D.modulate = Color(1, 1, 1)
