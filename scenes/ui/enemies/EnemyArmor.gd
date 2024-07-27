extends PanelContainer

@onready var armor = $"."

@onready var label = armor.get_child(1)

# Called when the node enters the scene tree for the first time.
func _set_armorbar(num: int):
	var value: String = str(num)
	label.text = value
	

func _set_armorbar_init(max_hp: int):
	var value: String = str(max_hp)
	label.text = value
