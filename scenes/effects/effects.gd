extends Node2D

@onready var burn_animation = $BurnAnimation/CharacterBody2D/AnimatedSprite2D
@onready var weak_animation = $WeakAnimation/CharacterBody2D/AnimatedSprite2D
@onready var bolt_animation = $BoltAnimation/CharacterBody2D/AnimatedSprite2D
@onready var arrow_rain_animation = $ArrowRainAnimation/CharacterBody2D/AnimatedSprite2D
@onready var stun_animation = $StunAnimation/CharacterBody2D/AnimatedSprite2D
@onready var heal_animation = $HealAnimation/CharacterBody2D/AnimatedSprite2D
@onready var slash_animation = $SlashAnimation/CharacterBody2D/AnimatedSprite2D
@onready var dead_animation = $DeadAnimation/CharacterBody2D/AnimatedSprite2D
@onready var shield_animation = $ShieldAnimation/CharacterBody2D/AnimatedSprite2D

@onready var burn_node = $BurnAnimation
@onready var weak_node = $WeakAnimation
@onready var bolt_node = $BoltAnimation
@onready var arrow_node = $ArrowRainAnimation
@onready var stun_node = $StunAnimation
@onready var heal_node = $HealAnimation
@onready var slash_node = $SlashAnimation
@onready var dead_node = $DeadAnimation
@onready var shield_node= $ShieldAnimation

func _ready():
	visible = true
	
func displayEffect(count: int):
	if count == 1:
		burn_node.visible = true
		burn_animation.visible = true
		burn_animation.play()
	
	elif count == 2:
		weak_node.visible = true
		weak_animation.play()
		weak_animation.visible = true
	
	elif count == 3:
		bolt_node.visible = true
		bolt_animation.play()
		bolt_animation.visible = true 
		
	elif count == 4:
		arrow_node.visible = true
		arrow_rain_animation.play()
		arrow_rain_animation.visible = true
		
	elif count == 5:
		stun_node.visible = true
		stun_animation.play()
		stun_animation.visible = true
	
	elif count == 6:
		heal_node.visible = true
		heal_animation.play()
		heal_animation.visible = true
		
	elif count == 7:
		slash_node.visible = true
		slash_animation.play()
		slash_animation.visible = true
		
	elif count == 8:
		dead_node.visible = true
		dead_animation.play()
		dead_animation.visible = true
	
	elif count == 9:
		shield_node.visible = true
		shield_animation.play()
		shield_animation.visible = true
