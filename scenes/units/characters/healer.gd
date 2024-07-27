class_name Healer extends Character

@onready var heal_animation = $HealAnimation/CharacterBody2D/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	maxHp = 6
	hp = 6
	armor = 2
	health_bar._set_healthbar_init(maxHp)
	armor_bar._set_armorbar_init(armor)
	return

func setup(player_data: Statics.PlayerData, class_card):
	super.setup(player_data, class_card)
	
	if is_multiplayer_authority():
		var HealingWord = load("res://Cards/HealerCards/HealingWord.tscn")
		var StickAttack = load("res://Cards/HealerCards/StickAttack.tscn")
		var Clarity = load("res://Cards/HealerCards/Clarity.tscn")
		
		var Carta1 = HealingWord.instantiate()
		var Carta2 = StickAttack.instantiate()
		var Carta3 = Clarity.instantiate()
		var Carta4 = HealingWord.instantiate()
		var Carta5 = StickAttack.instantiate()
		var Carta6 = Clarity.instantiate()
		deck = [Carta1, Carta2, Carta3, Carta4, Carta5, Carta6]
		
		deck.shuffle()
		
		for card in deck:
			card.player = self
		Game.playspace.setDeck(deck)
	
func generate_rewards():
	var HealingWord = load("res://Cards/HealerCards/HealingWord.tscn")
	var StickAttack = load("res://Cards/HealerCards/StickAttack.tscn")
	var Clarity = load("res://Cards/HealerCards/Clarity.tscn")	
	var MassHealingWord = load("res://Cards/HealerCards/Uncommon/MassHealingWord.tscn")	
	var PrayersOfPain = load("res://Cards/HealerCards/Rare/PrayersOfPain.tscn")	
	var Carta1 = HealingWord.instantiate()
	var Carta2 = StickAttack.instantiate()
	var Carta3 = Clarity.instantiate()
	var Carta4 = MassHealingWord.instantiate()
	var Carta5 = PrayersOfPain.instantiate()
	var cards = [Carta1, Carta2, Carta3, Carta4, Carta5]
	for card in cards:
			card.player = self
	var probabilidades = [0.25, 0.25, 0.25, 0.15, 0.10]
	var list = choose_random_card(cards, probabilidades)	
	return 	list
		
