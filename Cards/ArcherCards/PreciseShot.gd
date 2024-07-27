extends Cards

#Cargamos la base de datos del guerrero
@onready var ArcherChardDB = load("res://Cards/DataBase/ArcherDB.gd")

#Obtenemos el nombre de la carta que queremos obtener
var CardNameDicc = "SimpleShot"

#Datos del diccionario
@onready var CardInfo = ArcherChardDB.ARCHER_CARDS_SET[CardNameDicc]
#Axe Attack
@onready var CardName = CardInfo[0]
#IconAxeCard
@onready var CardIconImgName = CardInfo[1]
#1
@onready var CardActionCost = CardInfo[2]
#Deal 2 points of damage to one target
@onready var CardDescription = CardInfo[3]
#Common
@onready var CardRarity = CardInfo[4]

func _ready():
	super._ready()
	card_id = 9
	type_card = Single
	count_targets = 1
		
#Función que aplica efecto de una carta a un enemigo
func playCard(enemy: Unit):
	enemy.slashAnimation()
	
	await GlobalTimer.get_tree().create_timer(1).timeout
	enemy.slashAnimation()
	
	await GlobalTimer.get_tree().create_timer(1).timeout
	enemy.slashAnimation()
	enemy.takeDamage(1)
	enemy.takeDamage(1)
	enemy.takeDamage(1)
