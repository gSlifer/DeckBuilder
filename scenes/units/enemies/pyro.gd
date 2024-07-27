extends Enemigo

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	maxHp = 4
	hp = 4
	armor = 2
	hpBar._set_healthbar_init(maxHp)
	armorBar._set_armorbar_init(armor)
	return

func attack_random_player():
	var target_index = rng.randi_range(0, main.party.size() - 1)
	var first_target = main.party[target_index]
	var mtarget = first_target
	while mtarget.ailment == mtarget.KO || (mtarget.ailment == mtarget.BURN && mtarget.ailment_duration == 3):
		target_index+=1
		mtarget = main.party[(target_index) % main.party.size()]
		if mtarget == first_target:
			break
	mtarget.take_burn(1)
