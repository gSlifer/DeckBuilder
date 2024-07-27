extends Node2D

#Imagen carta completa
@export var cardImg: Sprite2D = null

@onready var animation = $animation

@onready var bottom9 = $PlayCard9
@onready var top9 = $PlayCard9/top

@onready var bottom10 = $PlayCard10
@onready var top10 = $PlayCard10/top

@onready var bottom11 = $PlayCard11
@onready var top11 = $PlayCard11/top

@onready var bottom12 = $PlayCard12
@onready var top12 = $PlayCard12/top

# Called when the node enters the scene tree for the first time.
func drawAnim():
	if cardImg == null:
		print("No hay imagen de carta definida")
		return
	
	#Asignamos la carta completa a los nodos obtenidos
	#creamos copias de la imagen de la carta creando nuevas instancias
	#la agregamos a cada instancia
	var duplicate1 = cardImg.duplicate()
	animation.add_child(duplicate1)
	duplicate1.position.x = 50.5
	duplicate1.position.y = 63.5
	
	#repetimos con los demas nodos
	var duplicate2 = cardImg.duplicate()
	bottom9.add_child(duplicate2)
	bottom9.move_child(duplicate2, 0)
	duplicate2.position.x = 49
	duplicate2.position.y = 64
	
	var duplicate3 = cardImg.duplicate()
	top9.add_child(duplicate3)
	duplicate3.position.x = 50
	duplicate3.position.y = 25
	
	var duplicate4 = cardImg.duplicate()
	
	bottom10.add_child(duplicate4)
	bottom10.move_child(duplicate4, 0)
	duplicate4.position.x = 47
	duplicate4.position.y = 67
	duplicate4.rotation_degrees = 5
	
	var duplicate5 = cardImg.duplicate()
	top10.add_child(duplicate5)
	duplicate5.position.y = -19
	duplicate5.position.x = 1
	
	var duplicate6 = cardImg.duplicate()
	bottom11.add_child(duplicate6)
	bottom11.move_child(duplicate6, 0)
	duplicate6.position.x = 49.5
	duplicate6.position.y = 109.5
	duplicate6.rotation_degrees = 10
	
	var duplicate7 = cardImg.duplicate()
	top11.add_child(duplicate7)
	duplicate7.position.y = 64.5
	duplicate7.position.x = 55.5
	duplicate7.rotation_degrees = -3
	
	var duplicate8 = cardImg.duplicate()
	bottom12.add_child(duplicate8)
	bottom12.move_child(duplicate8, 0)
	duplicate8.position.x = 53
	duplicate8.position.y = 111.5
	duplicate8.rotation_degrees = 10
	
	var duplicate9 = cardImg.duplicate()
	top12.add_child(duplicate9)
	duplicate9.position.x = 53.5
	duplicate9.position.y = 14.5
	duplicate9.rotation_degrees = -11
	
	cardImg.visible = false
