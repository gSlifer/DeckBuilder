class_name Archer extends Character

@onready var heal_animation = $HealAnimation/CharacterBody2D/AnimatedSprite2D

func _ready():
	super._ready()
	maxHp = 8
	hp = 8
	armor = 0
	health_bar._set_healthbar_init(maxHp)
	armor_bar._set_armorbar_init(armor)
	return

func setup(player_data: Statics.PlayerData, class_card):
	super.setup(player_data, class_card)
	
	if is_multiplayer_authority():
		var ArrowRain = load("res://Cards/ArcherCards/ArrowRain.tscn")
		var Burns = load("res://Cards/ArcherCards/Burns.tscn")
		var PreciseShot = load("res://Cards/ArcherCards/PreciseShot.tscn")
		
		var Carta1 = ArrowRain.instantiate()
		var Carta2 = Burns.instantiate()
		var Carta3 = PreciseShot.instantiate()
		var Carta4 = ArrowRain.instantiate()
		var Carta5 = Burns.instantiate()
		var Carta6 = PreciseShot.instantiate()
		
		deck = [Carta2, Carta1, Carta3, Carta4, Carta5, Carta6]
		deck.shuffle()
		for card in deck:
			card.player = self
		Game.playspace.setDeck(deck)

func generate_rewards():
	var ArrowRain = load("res://Cards/ArcherCards/ArrowRain.tscn")
	var Burns = load("res://Cards/ArcherCards/Burns.tscn")
	var PreciseShot = load("res://Cards/ArcherCards/PreciseShot.tscn")
	var HeavyArrow = load("res://Cards/ArcherCards/Uncommon/HeavyArrow.tscn")
	var DestructionRain = load("res://Cards/ArcherCards/Rare/DestructionRain.tscn")
	var Carta1 = ArrowRain.instantiate()
	var Carta2 = Burns.instantiate()
	var Carta3 = PreciseShot.instantiate()
	var Carta4 = HeavyArrow.instantiate()
	var Carta5 = DestructionRain.instantiate()
	var cards = [Carta1, Carta2, Carta3, Carta4, Carta5]
	for card in cards:
			card.player = self
	var probabilidades = [0.25, 0.25, 0.25, 0.15, 0.10]
	var list = choose_random_card(cards, probabilidades)	
	return 	list
