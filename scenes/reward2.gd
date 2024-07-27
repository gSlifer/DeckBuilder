extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _gui_input(event):
	if Input.is_action_just_released("left_click"):
		Game.playspace.add_reward_to_deck(1)
