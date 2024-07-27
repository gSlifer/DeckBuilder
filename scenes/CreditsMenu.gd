extends VBoxContainer

@onready var back: Button = %BackToMenu
@onready var background_credits = $BackgroundCredits

@export var visibleBackground: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	background_credits.visible = visibleBackground

func connect_signal():
	back.pressed.connect(_on_backoption_pressed)
	
func _on_backoption_pressed():
	visible = false
	if Game.main.control_menu != null:
		Game.main.control_menu.visible = false
