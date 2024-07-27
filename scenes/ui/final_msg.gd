extends Control
@onready var final_message = $"."
@onready var label = $MarginContainer/Label
@onready var texture_rect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	final_message.visible = false

@rpc("any_peer","reliable","call_local")
func show_message(victory: bool):
	if !victory:
		texture_rect.texture = load("res://assets/UI/messages/defeatbg.png")
		change_message("Defeat")
	
	final_message.visible = true
	
func change_message(new_msg: String):
	label.text = new_msg
