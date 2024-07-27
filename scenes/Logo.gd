extends Node

#Timer para ver tiempo de inicio del juego
@onready var timer = $StartGameTimer
@onready var escene = $Escene
# Variables de control
var alpha = 1.0
var decrease_speed = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.multiplayer_test:
		get_tree().change_scene_to_file("res://scenes/lobby_test.tscn")
		return
		
	#timer.connect("timeout", _on_timer_timeout)
	#timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if alpha > 0.0:
		if timer.is_stopped():
			escene.set_modulate(Color(1, 1, 1, alpha))
			alpha -= decrease_speed
	else:
		timer.start()
		get_tree().change_scene_to_file("res://scenes/lobby.tscn")
		
func _on_timer_timeout():
	set_process(true)
