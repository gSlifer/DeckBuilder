extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _set_armorbar(num: int):
	if num < 0:
		value = 0
	else:
		if num >= max_value:
			value = max_value
		else:
			value = num

func _set_armorbar_init(armor: int):
	max_value = 12
	value = armor
