extends AnimatedSprite2D

var alfa = 0.8
var speed = 0.01
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if (frame == 18):
		if (alfa > 0):
			set_modulate(Color(1, 1, 1, alfa))
			alfa-=speed
		visible = false
