class_name Enemigo extends Character

var target = null 
var stats

@onready var portrait = $Control

@onready var hpBar = portrait.get_child(6)
@onready var armorBar =  portrait.get_child(7)
@onready var mseed
@onready var rng

func _ready():
	super._ready()
	maxHp = 5
	hp = 5
	armor = 3
	hpBar._set_healthbar_init(maxHp)
	armorBar._set_armorbar_init(armor)
	return

func _setup(newSeed: int):
	turn_finished.connect(main.on_turn_finished_local)
	mseed = newSeed
	name = str(newSeed)
	rng = RandomNumberGenerator.new()
	rng.seed = mseed*10

func startTurn():
	i_am_next.visible = false
	# Ailment management
	ailmentAction()
	
	# Turn management
	if ailment != STUN && ailment != KO:
		state = PLAY
		#Debug.sprint("Its " + unit_name + "'s turn!", 500)
		attack_random_player()
	
	if is_multiplayer_authority():
		turn_finished.emit()
	
	ailment_countdown()
	 
func attack_random_player():
	var target_index = rng.randi_range(0, main.party.size() - 1)
	var mtarget = main.party[target_index]
	while mtarget.ailment == mtarget.KO:
		target_index+=1
		mtarget = main.party[(target_index) % main.party.size()]
	var damage = rng.randi_range(4, 6)
	mtarget.takeDamage(damage)
	
func setCurrentHp(chp: int):
	super.setCurrentHp(chp)
	hpBar._set_healthbar(hp)

func DmgToArmor(value: int):
	super.DmgToArmor(value)
	armorBar._set_armorbar(armor)

func takeDamage(val: int): 
	super.takeDamage(val)

@rpc("any_peer", "reliable", "call_local")
func leaveGame():
	Game.list_targets.erase(self)
	Game.main.enemy_party.erase(self)
	Game.main.turn_order.erase(self)
	queue_free()
