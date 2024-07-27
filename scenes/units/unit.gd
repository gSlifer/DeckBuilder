extends Node2D

class_name Unit

signal state_changed(state)

#stats
var maxHp: int
var hp: int
var armor: int
var unit_name: String

#ailment
enum{
	NONE,
	STUN,
	KO,
	BURN,
	WEAK
}

#ailment duration
var ailment_duration = 0:
	set(value):
		ailment_duration = value
		if 0 < value:
			ailment_time.visible = true
			ailment_time.text = str(value)
		else:
			ailment_time.visible = false

var ailment = NONE:
	set(value):
		#ailment set
		if ailment != KO:
			ailment = value
		
		#ailment visual set
		ailment_icon.visible = false
		if ailment == NONE:
			$Sprite2D.visible = true
		elif ailment == KO:
			
			$Sprite2D.visible = false
			state = HOLD
		else:
			if ailment == STUN:
				ailment_icon.texture = load("res://assets/ailments/stun.png")
				state = HOLD
			elif ailment == BURN:
				ailment_icon.texture = load("res://assets/ailments/fire.png")
			elif ailment == WEAK:
				ailment_icon.texture = load("res://assets/ailments/weakness.png")
			ailment_icon.visible = true

#animation
var tween: Tween
@onready var i_am_next: Label = $Control/NextLabel
@onready var ailment_icon: TextureRect = $Control/AilmentTexture
@onready var ailment_time = $Control/AilmentTexture/AilmentTime

#turns
signal turn_finished()

var state = HOLD:
	set(value):
		state = value
		state_changed.emit(state)

enum{
	HOLD,
	PLAY
}
var main: Node2D

func _init(mhp,chp,ac,nickname):
	maxHp = mhp
	hp = chp
	armor = ac
	unit_name = nickname

func takeDamageAnimation(damage: int):
	#var actual_position = position
	var power = float(damage)/float(4)
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", position + Vector2(power, power), 0.05)
	tween.tween_property(self, "position", position + Vector2(-power, -power), 0.05)
	tween.tween_property(self, "position", position + Vector2(-power, power), 0.05)
	tween.tween_property(self, "position", position + Vector2(power, -power), 0.05)
	tween.tween_property(self, "position", position, 0.05)
	
func takeDamage(dmg: int):
	if ailment == WEAK:
		dmg+=ailment_duration
	takeDamageAnimation((armor-dmg)*10)
	
	var dmg_restante = dmg-armor
	DmgToArmor(dmg)
	if dmg_restante > 0:
		setCurrentHp(hp - dmg_restante)

func setMaxHp(mhp: int):
	if mhp < 1:
		maxHp = 1
	else:
		maxHp = mhp
	
func setCurrentHp(chp: int):
	if ailment != KO:
		if chp <= 0:
			hp = 0
			ailment = KO
			ailment_duration = -1 #infinito
		
		else:
			if chp >= maxHp:
				hp = maxHp
			else:
				hp = chp

func DmgToArmor(value: int):
	if armor-value <= 0:
		armor = 0
	else:
		armor -= value

func setUnitName(nickname: String):
	unit_name = nickname

@rpc("reliable", "any_peer", "call_local")
func startTurn():
	# Ailment management
	ailmentAction()
	
	
	# Turn management
	if ailment != STUN && ailment != KO:
		state = PLAY
		

	else:
		if is_multiplayer_authority():
			turn_finished.emit()
	ailment_countdown()

@rpc("reliable", "any_peer", "call_local")
func endTurn():
	state = HOLD
	ailment_countdown()

@warning_ignore("unused_parameter")
func healthHpAnimation(health: int):
	pass

func take_burn(turns: int):
	if ailment != BURN:
		ailment = BURN
		ailment_duration = min(3, turns)
	else:
		ailment_duration = min(3, ailment_duration + turns)

func take_weak(turns: int):
	if ailment != WEAK:
		ailment = WEAK
		ailment_duration = min(2, turns)
	else:
		ailment_duration = min(2, ailment_duration + turns)

func take_stun(turns: int):
	ailment = STUN
	ailment_duration = turns

func remove_ailment(ail: int):
	if ailment == ail:
		ailment = NONE
		ailment_duration = 0

func ailmentAction():
	if ailment == NONE:
		return
	if ailment == BURN:
		takeDamage(2)
		takeDamageAnimation(20)

func canPlay():
	return ailment != KO and ailment != STUN and state != HOLD
		
func ailment_countdown():
	if(0 < ailment_duration):
		ailment_duration-=1
	if ailment_duration == 0:
		ailment = NONE

@rpc("any_peer", "reliable", "call_local")
func leaveGame():
	return
