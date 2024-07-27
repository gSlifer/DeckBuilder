class_name Mage extends Character

@onready var heal_animation = $HealAnimation/CharacterBody2D/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	maxHp = 7
	hp = 7
	armor = 0
	health_bar._set_healthbar_init(maxHp)
	armor_bar._set_armorbar_init(armor)
	return

func setup(player_data: Statics.PlayerData, class_card):
	super.setup(player_data, class_card)
	
	if is_multiplayer_authority():
		var BoltStrike = load("res://Cards/MageCards/BoltStrike.tscn")
		var Curse = load("res://Cards/MageCards/Curse.tscn")
		var ThunderStorm = load("res://Cards/MageCards/ThunderStorm.tscn")
		
		var Carta1 = BoltStrike.instantiate()
		var Carta2 = Curse.instantiate()
		var Carta3 = ThunderStorm.instantiate()
		var Carta4 = BoltStrike.instantiate()
		var Carta5 = Curse.instantiate()
		var Carta6 = ThunderStorm.instantiate()
		
		deck = [Carta1, Carta2, Carta3, Carta4, Carta5, Carta6]
		deck.shuffle()
		for card in deck:
			card.player = self
		Game.playspace.setDeck(deck)


func generate_rewards():
	var BoltStrike = load("res://Cards/MageCards/BoltStrike.tscn")
	var Curse = load("res://Cards/MageCards/Curse.tscn")
	var ThunderStorm = load("res://Cards/MageCards/ThunderStorm.tscn")
	var IceKnife = load("res://Cards/MageCards/Uncommon/IceKnife.tscn")
	var ConeOfFire = load("res://Cards/MageCards/Rare/ConeOfFire.tscn")
	var Carta1 = BoltStrike.instantiate()
	var Carta2 = Curse.instantiate()
	var Carta3 = ThunderStorm.instantiate()
	var Carta4 = IceKnife.instantiate()
	var Carta5 = ConeOfFire.instantiate()
	var cards = [Carta1, Carta2, Carta3, Carta4, Carta5]
	for card in cards:
			card.player = self
	var probabilidades = [0.25, 0.25, 0.25, 0.15, 0.10]
	var list = choose_random_card(cards, probabilidades)
	return 	list
