extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _gui_input(event):
	var current_player = null
	var main = get_node("/root/Main")
	
	for p in main.party:
		if p.is_multiplayer_authority():
			current_player = p

	
	if Input.is_action_just_released("left_click") and current_player != null:
		var discardSize = current_player.discard.size()
		Game.playspace.show_discarded()
