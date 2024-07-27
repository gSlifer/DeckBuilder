extends Node2D

class_name Cards

#Atributos para posicion de carta
var startpos = Vector2()
var targetpos = Vector2()
var startrot = 0
var targetrot = 0
var t = 0
var DRAWTIME = 0.3
var ORGANISETIME = 0.5
@onready var Orig_scale = scale.x

var state = Game.InDeck

var card_index
var can_play_card = false
var target_id = []

var player = null

var card_id = null

@onready var OverCard : Control = $OverCard

@onready var CardAnim = $CardAnim
@onready var sprite = $cardImg

#Tipo de carta
enum {None, Single, Multi, AoE}

#tipo de carta
var type_card = None
var count_targets = 0

func _ready():
	OverCard.mouse_entered.connect(_on_mouse_entered)
	OverCard.mouse_exited.connect(_on_mouse_exited)
	OverCard.mouse_filter = Control.MOUSE_FILTER_IGNORE #(2)
	z_as_relative = false
	z_index = 10
	if(sprite != null):
		CardAnim.cardImg = sprite
		CardAnim.drawAnim()

#Funcion cambia estado de la carta
func setState(new_state):
	state = new_state
	#print("State cambiado a ")
	#print(str(new_state))

func _physics_process(delta):
	match state:
		Game.InDeck:
			pass
		Game.InHand:
			OverCard.mouse_filter = Control.MOUSE_FILTER_STOP #(0)
		Game.InPlay:
			pass
		Game.InDiscardPile:
			pass
		Game.PlayingCard:
			pass
		Game.MoveDrawnCardToHand: # animate from the deck to my hand
			if t <= 1: # Always be a 1
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + targetrot*t
				scale.x = Orig_scale * abs(2*t - 1)
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta/float(DRAWTIME)
			else:
				position = targetpos
				rotation = targetrot
				setState(Game.InHand)
				t = 0
		Game.ReOrganiseHand:
			if t <= 1: # Always be a 1
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + targetrot*t
				t += delta/float(ORGANISETIME)
			else:
				position = targetpos
				rotation = targetrot
				setState(Game.InHand)
				t = 0
		Game.MoveCardDisplay:
			if t <= 1: # Always be a 1
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + targetrot*t
				scale.x = 1
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta/float(DRAWTIME)
			else:
				position = targetpos
				rotation = targetrot
				setState(Game.InDiscardPile)
				t = 0
#Función que escala imagen de una carta, necesario para que se vean bien en pantalla
func resize_ImgCard():
	#Asignamos todos los elementos a la carta
	#Obtenemos el ancho y largo del sprite que queremos poner en la carta
	var x = $Background/ImgCard.texture.get_width()
	var y = $Background/ImgCard.texture.get_height()
	#Obtenemos el ancho y el largo del marco donde va el sprite
	var m = $Background/Marco.texture.get_width()
	var n = $Background/Marco.texture.get_height()
	#Escalamos de tal forma que el sprite que queremos poner dentro del marco
	#no sea tan grande, le restamos un 10% al ancho ya que el sprite del marco
	#tiene un margen de algunos pixeles que se deben considerar para el escalado
	$Background/ImgCard.scale.x = 2*float(m)/float(x) - 0.09
	$Background/ImgCard.scale.y = 2*float(n)/float(y) - 0.055
	
#Función que captura los input
func _input(event):
	if event.is_action_pressed("play_card") and state == Game.InPlay and player.state == player.PLAY:
		if card_id != null and type_card == Multi and count_targets == target_id.size():
			Game.handler.playCard.rpc(card_id, target_id)
			setState(Game.InDiscardPile)
			
		elif card_id != null and type_card != Multi:
			Game.handler.playCard.rpc(card_id, target_id)
			setState(Game.InDiscardPile)
			
		Game.playspace.NumberCardsHand -= 1
		delete_card()

func delete_card():
	if state == Game.InDiscardPile:
		Game.playspace.removeHandCard(self)
		Game.playspace.addDiscardPileCard(self)
		Game.playspace.reorganiceHand()

#Si tenemos el mouse sobre una carta
func _on_mouse_entered():
	setState(Game.InPlay)
	Game.playspace.card = self
	Game.playspace.set_random_target(self)
	scale.x *= 1.5
	scale.y *= 1.5
	position.y += -100
	
	card_index = get_index()
	move_to_front()
	if (target_id.size() != 0):
		for id in target_id :
			Game.list_targets[id].display_target_animation()
	
	if type_card == Single or type_card == Multi:
		var id = Game.playspace.target_tmp
		Game.list_targets[id].display_target_animation()

#Función que se aplica cuando el mouse sale de la hitbox de la carta
func _on_mouse_exited():
	setState(Game.InHand)
	Game.playspace.card = null
	scale.x /= 1.5
	scale.y /= 1.5
	position.y -= -100
	
	get_parent().move_child(self, card_index)
	
	if (target_id.size() != 0):
		for id in target_id :
			Game.list_targets[id].disable_animation()
	
	var id = Game.playspace.target_tmp
	if id != null:
		Game.list_targets[id].disable_animation()
	
	target_id = []
	Game.playspace.target_tmp = null

func AnimCard():
	if CardAnim != null and CardAnim.animation != null:
		CardAnim.animation.play()
