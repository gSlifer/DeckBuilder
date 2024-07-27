extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _set_healthbar(num: int):
	value = num
	

func _set_healthbar_init(max_hp: int):
	max_value = max_hp
	value = max_hp
