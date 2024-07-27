extends Enemigo


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	maxHp = 12
	hp = 12
	armor = 12
	hpBar._set_healthbar_init(maxHp)
	armorBar._set_armorbar_init(armor)
	return

#prioriza weak
#si lowest y target tienen weak, al que tenga menos vida

func attack_random_player():
	#var first_target_index = rng.randi_range(0, main.party.size() - 1)
	#var target_index = first_target_index
	var mtarget: Unit
	@warning_ignore("unassigned_variable")
	var targets: Array
	for character in main.party:
		if character.ailment != mtarget.KO:
			if character.ailment == character.WEAK:
				mtarget = character
				break
			else:
				targets.append(character)
	if !mtarget:
		var index = rng.randi_range(0, targets.size() - 1)
		mtarget = targets[index]
	mtarget.takeDamage(1)
	mtarget.takeDamage(1)
	mtarget.takeDamage(1)
	mtarget.takeDamage(3)

#func attack_random_player(): #heal en este caso
	#var rng = RandomNumberGenerator.new()
	#var target_index = 0
	#var target: Unit = main.enemy_party[target_index]
	#var lowest = target
	#while target.ailment == target.KO:
		#target_index+=1
		#target = main.enemy_party[target_index % main.enemy_party.size()]
		#if target == main.enemy_party[0]:
			#break
		#elif target.hp < lowest.hp:
			#lowest = target
	#lowest.get_heal(2)

