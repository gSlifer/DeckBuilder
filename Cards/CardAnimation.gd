extends AnimatedSprite2D

@onready var frame9 = $"../PlayCard9"
@onready var frame10 = $"../PlayCard10"
@onready var frame11 = $"../PlayCard11"
@onready var frame12 = $"../PlayCard12"
@onready var frame12_2 = $"../PlayCard12/top"

var alpha = 0.8
var decrease_speed = 0.4

func _ready():
	if frame == 0:
		stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if frame == 9:
		visible = false
		frame9.visible = true
	
	elif frame == 10:
		frame9.visible = false
		frame10.visible = true
	
	elif frame == 11:
		frame10.visible = false
		frame11.visible = true
		
	elif frame == 12:
		frame11.visible = false
		frame12.visible = true
		if alpha > 0.0:
			frame12.set_modulate(Color(1, 1, 1, alpha))
			frame12_2.set_modulate(Color(1,1,1,alpha))
			alpha -= decrease_speed
		visible = false
	else:
		visible = true
		frame9.visible = false
		frame10.visible = false
		frame11.visible = false
		frame12.visible = false
