extends VBoxContainer

@onready var back: Button = %BackToMenu
@onready var background_credits = $BackgroundCredits
@onready var prev: Button = %Prev
@onready var next: Button = %Next
@onready var SupBar = null
@onready var LabelOptions = null
@onready var ContainerOptions = null
@onready var options_menu = null
@export var visibleBackground: bool = true
var i = 0
var max_value = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	background_credits.visible = visibleBackground
	prev.pressed.connect(_on_prev_pressed)
	next.pressed.connect(_on_next_pressed)
	back.pressed.connect(_on_backoption_pressed)

func _on_backoption_pressed():	
	if (options_menu != null):
		options_menu.visible = true
	visible = false
	if (SupBar != null):
		SupBar.visible = true
	if (LabelOptions != null):
		LabelOptions.visible = true	
	if (ContainerOptions != null):
		ContainerOptions.visible = true				
		
func _on_prev_pressed():
	i = (i - 1 + (max_value + 1)) % (max_value + 1)
	if (i == 0):
		$Label.text = "LAYOUT"
		$Tut1.visible = true
		$Tut2.visible = false
		$Tut3.visible = false
	if (i == 1):
		$Label.text = "CONTROLS"
		$Tut1.visible = false
		$Tut2.visible = true
		$Tut3.visible = false
	if (i == 2):
		$Label.text = "TIPS"
		$Tut1.visible = false
		$Tut2.visible = false
		$Tut3.visible = true
	
func _on_next_pressed():
	i = (i + 1) % (max_value + 1)
	if (i == 0):
		$Label.text = "LAYOUT"
		$Tut1.visible = true
		$Tut2.visible = false
		$Tut3.visible = false
	if (i == 1):
		$Label.text = "CONTROLS"
		$Tut1.visible = false
		$Tut2.visible = true
		$Tut3.visible = false
	if (i == 2):
		$Label.text = "TIPS"
		$Tut1.visible = false
		$Tut2.visible = false
		$Tut3.visible = true
