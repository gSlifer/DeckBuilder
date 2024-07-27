extends Node2D

#Tamaño de las cartas
const CardSize = Vector2(95,130)

@onready var FinalMessage = $FinalMessage
@onready var Reward = %Reward
@onready var reward1 = %reward1
@onready var reward2 = %reward2
@onready var reward3 = %reward3

@onready var DeckSize = 0
#Variables robo cartas
@onready var ViewportSize = Vector2(get_viewport().size)
@onready var CentreCardOval = $CentreCardOval.position
@onready var Hor_rad = $RadMark.position.x
@onready var Ver_rad = $RadMark.position.y
var angle = 0
var OvalAngleVector = Vector2()
var CardOffset = Vector2()
var CardSpread = 0.25
var NumberCardsHand = 0
var Card_Numb = 0
var maxCards = 0

var target_id = []
var target_tmp = null	# el preseleccionado

#Usar para saber que carta llamar(aun no terminado)
var card = null

var deck_cards = []
var discard_cards = []

var AoeHealing = false
@onready var deck = $Deck
@onready var discard = $Discard
@onready var hand = $Hand
@onready var pile = $Pile

func _ready():
	Game.playspace = self
	
func setDeck(new_deck):
	if new_deck != null:
		deck_cards = new_deck
		DeckSize = deck_cards.size()

func removeDeckCard(rcard):
	deck_cards.erase(rcard)

func addDeckCard(rcard):
	deck_cards.append(rcard)

func removeHandCard(rcard):
	$Hand.remove_child(rcard)
	
func addHandCard(rcard):
	$Hand.add_child(rcard)
	#print("Carta añadida a la mano")

func removeDiscardPileCard(rcard):
	discard_cards.erase(rcard)

func addDiscardPileCard(rcard):
	rcard.scale.x = 1
	rcard.scale.y = 1
	rcard.rotation = 0
	rcard.targetrot = 0
	discard_cards.append(rcard)

func drawcard():

	if deck_cards.size() == 0:
		for c in discard_cards:
			addDeckCard(c)
			removeDiscardPileCard(c)
			deck_cards.shuffle()
		#número de cartas en la mano; cantidad de veces que puedes robar cartas
	if (NumberCardsHand < 3):
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
		var new_card = deck_cards[0]
		deck_cards.remove_at(0)
				
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		new_card.scale *= 0.7
		new_card.startpos = $Deck.position - CardSize/2
		new_card.targetpos = CentreCardOval + OvalAngleVector - CardSize
		new_card.startrot = 0
		new_card.targetrot = (PI/2 - angle)/4 # 180 = Pi
		new_card.setState(Game.MoveDrawnCardToHand)
		
		reorganiceHand()
		addHandCard(new_card)

		angle += 0.25
		DeckSize -= 1
		NumberCardsHand += 1
		maxCards += 1
		return

func set_random_target(rcard):
	if Game.list_targets.size() != 0:
		var target_list = Game.list_targets
		
		if rcard.type_card == rcard.Single or rcard.type_card == rcard.Multi:
			#Pick random target
			var rng = RandomNumberGenerator.new()
			var random_target_id = rng.randi_range(0,target_list.size()-1)
			target_tmp = random_target_id
		
		elif rcard.type_card == rcard.AoE:
			#Asigno nuevos objetivos
			rcard.target_id = []
			AoeHealing = false
			if rcard.card_id == 15 || rcard.card_id == 16:
				AoeHealing = true
			if AoeHealing:
				for unit in Game.main.party:
					rcard.target_id.append(Game.list_targets.find(unit))
			else:
				for unit in Game.main.enemy_party:
					rcard.target_id.append(Game.list_targets.find(unit))
			#for j in range(0, Game.list_targets.size()):
				##Si j >3 entonces son solo enemigos
				#if j >Game.main.party.size()-1 and not AoeHealing:
					#rcard.target_id.append(j)
					#
				#elif AoeHealing and j <= Game.main.party.size()-1:
					#rcard.target_id.append(j)

#Si es que recibimos un input
func _input(event):
	#Si queremos cambiar el target a uno de la izquierda(en el arbol es subir)
	if event.is_action_pressed("left_change_target"):
		if card != null:
			if card.type_card == card.Single or card.type_card == card.Multi:
				#Si hay una animación activa entonces procedemos
					var targets =  Game.list_targets
					#Si tenemos 4 jugadores quiere decir que todo va bien
					if targets.size() > 0:
						targets[target_tmp].disable_animation()
						if target_tmp == 0:
							target_tmp = targets.size()-1
							#Activamos animación de nuevo target
							#update_targets(target_tmp)
							call_display_animation()
						else:
							target_tmp = (target_tmp-1)
							#Activamos animación de nuevo aliado
							#update_targets(target_tmp)
							call_display_animation()

	#Si queremos cambiar el target a uno de la deredcha(en el arbol es bajar)
	if event.is_action_pressed("right_change_target"):
		if card  != null:
			if card.type_card == card.Single or card.type_card == card.Multi:
					var targets =  Game.list_targets
					#Si tenemos 4 jugadores quiere decir que todo va bien
					if targets.size() > 0:
						targets[target_tmp].disable_animation()
						if target_tmp == targets.size()-1:
							target_tmp = 0
							#Activamos animación de nuevo target
							#update_targets(target_tmp)
							call_display_animation()
						else:
							target_tmp = (target_tmp+1)
							#Activamos animación de nuevo aliado
							#update_targets(target_tmp)
							call_display_animation()
							
	if event.is_action_pressed("select_target"):
		if card != null:
			if card.type_card == card.Multi:
				if card.target_id.has(target_tmp):
					card.target_id.erase(target_tmp)
				else:
					card.target_id.append(target_tmp)
			elif card.type_card == card.Single:
				for target in card.target_id:
					Game.list_targets[target].disable_animation()
				card.target_id = [target_tmp]
			call_display_animation()

#Funcion globla temporal
func call_display_animation():
	if target_tmp != null:
		Game.list_targets[target_tmp].display_target_animation()
	for target in card.target_id:
		Game.list_targets[target].display_selected_animation()

func reorganiceHand():
	Card_Numb = 0
	for Card in $Hand.get_children(): # reorganise hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - Card_Numb)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		
		Card.targetpos = CentreCardOval + OvalAngleVector - CardSize
		Card.startrot = Card.rotation
		Card.targetrot = (PI/2 - angle)/4 # 180 = Pi
		
		Card_Numb += 1
		if Card.state == Game.InHand:
			Card.setState(Game.ReOrganiseHand)
			Card.startpos = Card.position
		elif Card.state == Game.MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.position)/(1-Card.t))

func update_targets(card_target_id):
	var cards = get_tree().get_nodes_in_group("view_card")
	for rcard in cards:
		if rcard.type_card == rcard.Single:
			rcard.target_id = [card_target_id]

func show_discarded():
	$Dim.visible = not $Dim.visible
	if ($Dim.visible == true):
		var prev = 0
		var ylevel = 0
		var xlevel = 0
		for i in range(discard_cards.size()):
			var new_card = discard_cards[i]
			new_card.startpos = $Deck.position - CardSize/2
			@warning_ignore("integer_division")
			ylevel = floor(i/4)*250
			if (ylevel > prev):
				xlevel = 0	
			prev = ylevel
			new_card.targetpos = Vector2($Pos1.position.x + xlevel * 180, $Pos1.position.y + ylevel)
			xlevel += 1
			new_card.setState(Game.MoveCardDisplay)
			addDiscardCard(new_card)
	if ($Dim.visible == false):
		while $Pile.get_child_count() > 0:
			$Pile.remove_child($Pile.get_child(0))
	return

func addDiscardCard(rcard):
	$Pile.add_child(rcard)

@rpc("reliable", "call_local", "any_peer")
func startDrawCard():
	maxCards = 0
	
	var pj = null
	for p in Game.main.party:
		if p.is_multiplayer_authority():
			pj = p

	if pj != null:
		if pj.canPlay():
			var i = 0
			while maxCards < 3:
				if i == 3:
					break
				drawcard()
				i += 1


func playerDead():
	for rcard in deck.get_children():
		rcard.queue_free()
	
	for rcard in discard.get_children():
		rcard.queue_free()
		
	for rcard in hand.get_children():
		rcard.queue_free()
		
	for rcard in pile.get_children():
		rcard.queue_free()
		
func addReward(rcard):
	Reward.add_child(rcard)	
	
var pos_rewards	
	
func show_rewards(c1, c2, c3):
	$CanvasLayer.visible = true
	pos_rewards = []
	pos_rewards.append(c1)
	pos_rewards.append(c2)
	pos_rewards.append(c3)
	$Dim.visible = true
	$rw.visible = true
	reward1.visible = true
	reward2.visible = true
	reward3.visible = true
	c1.startpos = $Deck.position - CardSize/2
	c1.targetpos = $r1.position
	c1.setState(Game.MoveCardDisplay)
	addReward(c1)
	c2.startpos = $Deck.position - CardSize/2
	c2.targetpos = $r2.position
	c2.setState(Game.MoveCardDisplay)
	addReward(c2)
	c3.startpos = $Deck.position - CardSize/2
	c3.targetpos = $r3.position
	c3.setState(Game.MoveCardDisplay)
	addReward(c3)
	return

func add_reward_to_deck(i):
	var reward = pos_rewards[i]
	pos_rewards.erase(reward)
	addDeckCard(reward)
	clear_rewards()
	
func clear_rewards():
	$CanvasLayer.visible = false
	$Dim.visible = false
	$rw.visible = false
	reward1.visible = false
	reward2.visible = false
	reward3.visible = false
	while Reward.get_child_count() > 0:
			Reward.remove_child(Reward.get_child(0))
	pos_rewards.clear()
			
	
