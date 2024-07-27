class_name Character extends Unit

@onready var control = $Control
@onready var label: Label = $Control/PanelContainer/Name
@onready var health_bar: TextureProgressBar = $Control/TextureHealthBar
@onready var armor_bar: TextureProgressBar = $Control/TextureArmorBar
@onready var _animation_player = $SelectAnimation/CharacterBody2D/AnimatedSprite2D
@onready var deck = []
@onready var discard = []
@onready var effects = $Control/Effects

var classCard = null

func _init(mhp = 1, chp = 1, ac = 0, nickname = "Character"):
	super._init(mhp,chp,ac,nickname)
	deck = []
	#health_bar._set_healthbar_init(maxHp)
	
func _ready():
	state_changed.connect(on_state_changed)

func setup(player_data: Statics.PlayerData, class_card):
	turn_finished.connect(main.on_turn_finished_local)
	name = str(player_data.id)
	classCard = class_card
	set_multiplayer_authority(player_data.id)

func setCharacterName(given_name: String):
	unit_name = given_name
	label.text = given_name

@rpc("reliable", "call_local", "any_peer")
func startTurn():
	super.startTurn()
	if is_multiplayer_authority():
		Game.playspace.startDrawCard()
	i_am_next.visible = false
	main.end_button.setPlayer(self)
	main.end_button.setTexture("res://assets/characters/marcos/CrimsonFantasyGUI/EndTurn.png")
	main.end_button.set_multiplayer_authority(name.to_int())

@rpc("any_peer", "call_local", "reliable")
func setNext(value):
	i_am_next.visible = value

#Va a crear la animación del personaje seleccionado
func display_selected_animation():
	_animation_player.play()
	$SelectAnimation.visible = true
	
func display_target_animation():
	$Sprite2D.modulate = Color.BLACK

#Deshabilita animación
func disable_animation():
	_animation_player.stop()
	$SelectAnimation.visible = false
	$Sprite2D.modulate = Color.WHITE

func setCurrentHp(chp: int):
	super.setCurrentHp(chp)
	if (hp <= 0):
		deadAnimation()
	health_bar._set_healthbar(hp)

func DmgToArmor(value: int):
	super.DmgToArmor(value)
	if (value < 0):
		shieldAnimation()
	armor_bar._set_armorbar(armor)
	
func on_state_changed(mstate):
	control.playing_texture.visible = mstate == PLAY
	
func get_player_id():
	return multiplayer.get_unique_id()
	
func burnAnimation():
	effects.displayEffect(1)
	
func weakAnimation():
	effects.displayEffect(2)
	
func boltAnimation():
	effects.displayEffect(3)
	
func arrowRainAnimation():
	effects.displayEffect(4)
	
func stunAnimation():
	effects.displayEffect(5)
	
func healAnimation():
	effects.displayEffect(6)
	
func slashAnimation():
	effects.displayEffect(7)
	
func deadAnimation():
	effects.displayEffect(8)
	
func shieldAnimation():
	effects.displayEffect(9)

@rpc("any_peer", "reliable", "call_local")
func leaveGame():
	Game.list_targets.erase(self)
	Game.main.party.erase(self)
	Game.main.turn_order.erase(self)
	if is_multiplayer_authority():
		Game.playspace.playerDead()
	queue_free()
	
func generate_rewards():
	var list = []
	return list
	
func rewards():
	var a = generate_rewards()
	if (a != null):
		Game.playspace.show_rewards(a[0], a[1], a[2])	

func choose_random_card(cards, probs):
	var lista = []
	for x in range(3):
		var rand_num = randf()
		var acumulador = 0.0
		for i in range(cards.size()):
			acumulador += probs[i]
			if rand_num <= acumulador:
				lista.append(cards[i])
				break
	return lista
