extends Area2D

@export var damage_amount: int = 5

func _init() -> void:
	# Connect the signal on this Area2D to the on_body_entered() function.
	# This could be done from the `Node` tab but that could get confusing when
	# using the object in other scenes.
	body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node2D):
	# Check if the collided body has a method called `damage`, in this case that means it's our player.
	if (body.has_method('damage')):
		body.damage(damage_amount)
