extends Enemigo


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	maxHp = 5
	hp = 5
	armor = 3
	hpBar._set_healthbar_init(maxHp)
	armorBar._set_armorbar_init(armor)
	return

func attack_random_player(): #heal en este caso
	var mtarget: Unit = main.enemy_party[0]
	for character in main.enemy_party:
		@warning_ignore("integer_division")
		if float((mtarget.hp*100)/mtarget.maxHp) > float((character.hp*100)/character.maxHp):
			mtarget = character
			mtarget.setCurrentHp(mtarget.hp + 4)
