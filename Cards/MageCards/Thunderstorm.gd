extends Cards

#Cargamos la base de datos del guerrero
@onready var MageCardDB = load("res://Cards/DataBase/MageDB.gd")

#Obtenemos el nombre de la carta que queremos obtener
var CardNameDicc = "BigSpell"

#Datos del diccionario
@onready var CardInfo = MageCardDB.MAGE_CARDS_SET[CardNameDicc]
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
	card_id = 7
	type_card = AoE
	count_targets = Game.list_targets.size()- Game.main.party.size()

#Función que aplica efecto de una carta a un enemigo
func playCard(enemy: Unit):
	enemy.boltAnimation()
	enemy.takeDamage(2)
