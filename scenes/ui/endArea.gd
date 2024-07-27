extends Area2D
@onready var sprite_2d = $"../Sprite2D"
@onready var end_button = $".."

signal turn_finished()

var player: Node2D
enum{
	HOLD,
	PLAY
}
@warning_ignore("unused_parameter")
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and is_multiplayer_authority():
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			turn_finished.emit()
			#player.endTurn.rpc()
			end_button.setTexture("res://assets/characters/marcos/CrimsonFantasyGUI/endturnidle.png")
