extends Node2D

#scenes and nodes
@onready var players = $Players
@export var warrior: PackedScene
@export var mage: PackedScene
@export var archer: PackedScene
@export var healer: PackedScene

# enemy generation
@onready var teams = $Teams
@onready var enemies = $Enemies
var enemy_array

#teams and turns
@onready var party = []
@onready var enemy_party = []
@onready var party_markers = $SpawnPoints/PartyPoints.get_children()
@onready var enemy_markers = $SpawnPoints/EnemyPoints.get_children()
@onready var turn_order = []
@onready var current_fighter: int = 0
@onready var end_button = $EndButton

@onready var option_menu = %OptionsMenu
@onready var control_menu = $Canvas/Control
@onready var htp = %Htp
enum{
	HOLD,
	PLAY
}

var rng = RandomNumberGenerator.new()


func _ready():
	Game.main = self
	end_button.end_area.turn_finished.connect(on_turn_finished_local)
	rng.seed = 0
	option_menu.htp = htp
	htp.options_menu = option_menu
	for playerData in Game.players:
		var player
		if(playerData.role == Statics.Role.ROLE_A):
			player = warrior.instantiate()
			player.main = self
			players.add_child(player)
			player.setup(playerData, "Warrior")
		if(playerData.role == Statics.Role.ROLE_B):
			player = mage.instantiate()
			player.main = self
			players.add_child(player)
			player.setup(playerData, "Wizard")
		if(playerData.role == Statics.Role.ROLE_C):
			player = archer.instantiate()
			player.main = self
			players.add_child(player)
			player.setup(playerData, "Archer")
		if(playerData.role == Statics.Role.ROLE_D):
			player = healer.instantiate()
			player.main = self
			players.add_child(player)
			player.setup(playerData, "Healer")
		player.setCharacterName(playerData.name)
		party.append(player)
		rng.seed += playerData.id
	party.sort_custom(func(a, b): return a.unit_name < b.unit_name)
	for i in range(0,4):
		party[i].position = party_markers[i].position
		Game.list_targets.append(party[i])
	
	teams.rng.seed = rng.seed
	rng.seed = 4865069851 #archer first after 1 round
	#rng.seed = 2906891032 #mage first
	create_enemies()
	
	await get_tree().create_timer(1).timeout
	turnShuffle()
	
	Music.playmusicBattle()

@rpc("any_peer", "reliable", "call_local")
func turnShuffle():
	if is_multiplayer_authority():
		var order_array = []
		var party_copy = range(0, party.size())
		var enemy_party_copy = range(0, enemy_party.size())
		
		var allies_count: int = 0
		var enemies_count: int = 0
		
		var first_ally_position = rng.randi_range(0, party_copy.size() - 1)
		var first_ally = party_copy.pop_at(first_ally_position)
		order_array.append({"index":first_ally, "party_select": 0})
		#set_turn_order.rpc(first_ally, 0)
		allies_count += 1
		
		while(party_copy.size() + enemy_party_copy.size() != 0):
			var party_select: int
			if(party_copy.size() == 0):
				party_select = 1
			elif(enemy_party_copy.size() == 0):
				party_select = 0
			elif(allies_count == 2):
				party_select = 1
			elif(enemies_count == 2):
				party_select = 0
			else:
				party_select = rng.randi_range(0, 1)
			
			if(party_select == 0):
				var unit_position = rng.randi_range(0, party_copy.size() - 1)
				var unit = party_copy.pop_at(unit_position)
				order_array.append({"index":unit, "party_select": 0})
				#set_turn_order.rpc(unit, 0)
				allies_count += 1
				enemies_count = 0
			else:
				var unit_position = rng.randi_range(0, enemy_party_copy.size() - 1)
				var unit = enemy_party_copy.pop_at(unit_position)
				order_array.append({"index":unit, "party_select": 1})
				#set_turn_order.rpc(unit, 1)
				enemies_count += 1
				allies_count = 0		
		startRound.rpc(order_array)
		
func get_party_member(id: int) -> Node:
	for member in party:
		if member.get_player_id() == id:
			return member
	return null	

@rpc("authority", "reliable", "call_local")
func set_turn_order(index : int, party_select: int):
	if(party_select == 0):
		turn_order.append(party[index])
	elif(party_select == 1):
		turn_order.append(enemy_party[index])

@rpc("call_local", "reliable")
func startRound(order_array):
	turn_order = []
	for pair in order_array:
		var party_select = pair.party_select
		var index = pair.index
		if(party_select == 0):
			turn_order.append(party[index])
		elif(party_select == 1):
			turn_order.append(enemy_party[index])
	
	if multiplayer.is_server():
		current_fighter = 0
		turn_order[current_fighter].startTurn.rpc()
		var next_fighter = current_fighter+1
		while(next_fighter < turn_order.size()):# N KO FIN
			if(turn_order[next_fighter].ailment != turn_order[next_fighter].KO): #Si está vivo
				turn_order[next_fighter].setNext.rpc(true)
				break
			next_fighter+=1 #si está muerto, siguiente

@rpc("any_peer", "reliable", "call_local")
func nextTurn():
	turn_order[current_fighter].endTurn.rpc()
	current_fighter+=1
	
	if(current_fighter >= turn_order.size()):
		turnShuffle()
	else:
		turn_order[current_fighter].startTurn.rpc()
		#turn_order[current_fighter].i_am_next.visible = false
		var next_fighter = current_fighter+1
		while(next_fighter < turn_order.size()):# N KO FIN
			if(turn_order[next_fighter].ailment != turn_order[next_fighter].KO): #Si está vivo
				turn_order[next_fighter].setNext.rpc(true)
				break
			next_fighter+=1 #si está muerto, siguiente

@rpc("any_peer", "reliable", "call_local")
func create_enemies():
	enemy_array = teams.get_team()
	if enemy_array == null:
		Music.pauseMusic()
		enemy_array = teams.get_boss()
		Music.playBossMusic()
	enemy_party = []
	for n in enemies.get_children():
		enemies.remove_child(n)
		n.queue_free() 
	for i in range(0, enemy_array.size()):
		var enemy = enemy_array[i].instantiate()
		enemy.main = self
		enemy._setup(i+rng.seed)
		enemies.add_child(enemy)
		enemy_party.append(enemy)
		enemy.position = enemy_markers[i].position
		Game.list_targets.append(enemy)
	return true

func on_turn_finished_local():
	if !endGame():
		if enemiesHasKO():
			create_enemies.rpc()
			clean_all.rpc()
			await get_tree().create_timer(1).timeout
			getRewards.rpc()
			turnShuffle.rpc()
			return
		nextTurn.rpc_id(1)

@rpc("reliable", "call_local", "any_peer")
func clean_all():
	cleanParty()
	clean_turn_order()

@rpc("reliable", "call_local", "any_peer")
func cleanParty():
	for unit in party:
		unit.state = unit.HOLD
		unit.i_am_next.visible = false

@rpc("reliable", "call_local", "any_peer")
func clean_turn_order():
	var curr_tmp = current_fighter
	for i in range(turn_order.size()-1, -1, -1): #i = [0, null, 2, 3, 4]
		if turn_order[i] != null && turn_order[i].ailment == turn_order[i].KO:
			turn_order[i].leaveGame.rpc()
			if i <= curr_tmp:
				current_fighter-=1
	Game.orderList.rpc()
	update_current_fighter.rpc(current_fighter)

@rpc("reliable", "call_local", "any_peer")
func update_current_fighter(value: int):
	current_fighter = value
		
@rpc("any_peer", "reliable", "call_local")
func getRewards():
	for p in party:
		if (p.is_multiplayer_authority()):
			p.rewards()
	
func print_message_on_server():
	pass

func playersHasKO():
	var count = 0
	for ally in players.get_children():
		if(ally.ailment == ally.KO):
			count += 1
	return count == players.get_children().size()

func enemiesHasKO():
	var count = 0
	for enemie in enemies.get_children():
		if(enemie.ailment == enemie.KO):
			count += 1
	return count == enemies.get_children().size()
	
func endGame():
	if playersHasKO():
		#Perdieron
		Game.playspace.FinalMessage.show_message.rpc(false)
		#detener
		return true

	elif enemiesHasKO() && teams.Boss_teams.is_empty():
			#Ganaron
			Music.playEndGameMusic()
			Game.playspace.FinalMessage.show_message.rpc(true)
			#detener juego
			return true
	return false

func _input(event):
	if event.is_action_pressed("options_menu"):
		option_menu.visible = true
		control_menu.visible = true
		option_menu.connect_signal()
