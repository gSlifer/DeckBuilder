extends Cards

#Cargamos la base de datos del guerrero
@onready var ArcherChardDB = load("res://Cards/DataBase/ArcherDB.gd")

#Obtenemos el nombre de la carta que queremos obtener
var CardNameDicc = "UncommonAttack"

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
	card_id = 17
	type_card = AoE
	count_targets = Game.list_targets.size()- Game.main.party.size()

#Función que aplica efecto de una carta a un enemigo
func playCard(enemy: Unit):
	enemy.weakAnimation()
	enemy.take_weak(1)
	
	await GlobalTimer.get_tree().create_timer(1).timeout
	enemy.slashAnimation()
	enemy.takeDamage(3)
