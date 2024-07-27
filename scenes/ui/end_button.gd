extends Node2D

@onready var end_area = $endArea
@onready var sprite_2d = $Sprite2D


func setPlayer(unit: Unit):
	end_area.player = unit

## setTexture recibe un string (que será un path hacia alguna imagen) para 
## setear la textura del botón acorde al estado del jugador
##
## Si el jugador está en HOLD -> Se carga la textura correspondiente a IdleEndTurn
## Si el jugador está en PLAT -> Se carga al textura correspondiente a EndTurn
func setTexture(texture: String):
	sprite_2d.texture=ResourceLoader.load(texture)
