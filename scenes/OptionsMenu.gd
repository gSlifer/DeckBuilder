extends VBoxContainer

@onready var volumen = AudioServer.get_bus_index("Master")
@onready var musica = %Musica
@onready var musicBus = AudioServer.get_bus_index("Musica")
@onready var backoption: Button = %BackOptions
@onready var background = $BackgroundMenu
@onready var htp = null
@onready var htp_button = %HowToPlayButton

@export var visibleBackground: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	background.visible = visibleBackground
	htp_button.pressed.connect(_on_htp_pressed)

func _on_volumen_value_changed(value):
	AudioServer.set_bus_volume_db(volumen, linear_to_db(value))

func _on_musica_toggled(toggled_on):
	AudioServer.set_bus_mute(musicBus, not toggled_on)

func connect_signal():
	backoption.pressed.connect(_on_backoption_pressed)
	if (htp!= null):
		htp.SupBar = $SupBar
		htp.LabelOptions = $Label
		htp.ContainerOptions = $Container
	
func _on_backoption_pressed():
	visible = false
	if Game.main != null && Game.main.control_menu != null:
		Game.main.control_menu.visible = false
		
func _on_htp_pressed():
	if (htp != null):
		visible = false
		htp.visible = true
		$SupBar.visible = false
		$Label.visible = false
		$Container.visible = false
		
