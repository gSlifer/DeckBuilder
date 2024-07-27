class_name Warrior extends Character

var target = null 

func _ready():
	super._ready()
	maxHp = 10
	hp = 10
	armor = 5
	health_bar._set_healthbar_init(maxHp)
	armor_bar._set_armorbar_init(armor)
	
	return

func setup(player_data: Statics.PlayerData, class_card):
	super.setup(player_data, class_card)
	
	if is_multiplayer_authority():
		var AxeAttack = load("res://Cards/WarriorCards/AxeAttack.tscn")
		var CoverAlly = load("res://Cards/WarriorCards/CoverAlly.tscn")
		var StunningStrike = load("res://Cards/WarriorCards/StunningStrike.tscn")
		
		var Carta1 = AxeAttack.instantiate()
		var Carta2 = CoverAlly.instantiate()
		var Carta3 = StunningStrike.instantiate()
		var Carta4 = AxeAttack.instantiate()
		var Carta5 = CoverAlly.instantiate()
		var Carta6 = StunningStrike.instantiate()
		
		deck = [Carta1, Carta2, Carta3, Carta4, Carta5, Carta6]
		deck.shuffle()
		for card in deck:
			card.player = self
		Game.playspace.setDeck(deck)

func generate_rewards():
	var AxeAttack = load("res://Cards/WarriorCards/AxeAttack.tscn")
	var CoverAlly = load("res://Cards/WarriorCards/CoverAlly.tscn")
	var StunningStrike = load("res://Cards/WarriorCards/StunningStrike.tscn")
	var FuriousAttack = load("res://Cards/WarriorCards/Uncommon/FuriousAttack.tscn")
	var DieWithGlory = load("res://Cards/WarriorCards/Rare/DieWithGlory.tscn")
	var Carta1 = AxeAttack.instantiate()
	var Carta2 = CoverAlly.instantiate()
	var Carta3 = StunningStrike.instantiate()
	var Carta4 = FuriousAttack.instantiate()
	var Carta5 = DieWithGlory.instantiate()
	var cards = [Carta1, Carta2, Carta3, Carta4, Carta5]
	for card in cards:
			card.player = self
	var probabilidades = [0.25, 0.25, 0.25, 0.15, 0.10]
	var list = choose_random_card(cards, probabilidades)
	return 	list
