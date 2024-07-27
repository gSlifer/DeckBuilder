extends PanelContainer
@onready var hp = $"."

@onready var label = hp.get_child(1)

# Called when the node enters the scene tree for the first time.
func _set_healthbar(num: int):
	var value: String = str(num)
	label.text = value
	

func _set_healthbar_init(max_hp: int):
	var value: String = str(max_hp)
	label.text = value
