extends Node2D

#Cargamos la base de datos del guerrero
@onready var CardDB = preload("res://Cards/DataBase/database.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.handler = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass

func autority():
	return is_multiplayer_authority()

@rpc("any_peer","call_local","reliable")
func playCard(id_card, target_id):
	var card = load(CardDB.CARDS_SET[id_card][0])
	
	var Carta = card.instantiate()
	if id_card == 15:
		for unit in Game.main.party:
			if unit.classCard == "Healer":
				Carta.player = unit
	if id_card == 19:
		for unit in Game.main.party:
			if unit.classCard == "Healer":
				Carta.player = unit
	if id_card == 16:

			for unit in Game.main.party:
				if unit.classCard == "Warrior":
					Carta.player = unit
					
	for target in target_id:
		
		var obj = Game.list_targets[target]
	
		Carta.playCard(obj)
