extends Node


signal players_updated
signal player_updated(id)

@export var multiplayer_test = false

# [ {id: int, name: string, rol: Rol} ]
var players: Array[Statics.PlayerData] = []
var playspace = null
var handler = null

#Enum de estados de la carta
#InHand: Carta en la Mano
#InPlay: Carta se puede jugar
#FocusInHand: No uso
#MoveDrawnCardToHand: Sacar de mazo y se mueve a mano
#ReOrganiseHand: Se organicen las cartas
enum{InDeck,InHand,InPlay,MoveDrawnCardToHand,ReOrganiseHand, InDiscardPile, PlayingCard, MoveCardDisplay}

# first one is server
@export var test_players: Array[PlayerDataResource] = []

# Emitted when UPnP port mapping setup is completed (regardless of success or failure).
signal upnp_completed(error)

# Replace this with your own server port number between 1024 and 65535.
const SERVER_PORT = 5409
var thread = null

var list_targets = []
var main = null

func add_player(player: Statics.PlayerData) -> void:
	players.append(player)
	players_updated.emit()


func remove_player(id: int) -> void:
	for i in players.size():
		if players[i].id == id:
			players.remove_at(i)
			break
	players_updated.emit()


func get_player(id: int) -> Statics.PlayerData:
	for player in players:
		if player.id == id:
			return player
	return null


func get_current_player() -> Statics.PlayerData:
	return get_player(multiplayer.get_unique_id())


@rpc("any_peer", "reliable", "call_local")
func set_player_role(id: int, role: Statics.Role) -> void:
	var player = get_player(id)
	player.role = role
	player_updated.emit(id)


func set_current_player_role(role: Statics.Role) -> void:
	set_player_role.rpc(multiplayer.get_unique_id(), role)


func is_online() -> bool:
	return not multiplayer.multiplayer_peer is OfflineMultiplayerPeer and \
		multiplayer.multiplayer_peer.get_connection_status() != MultiplayerPeer.CONNECTION_DISCONNECTED


func _upnp_setup(server_port):
	# UPNP queries take some time.
	var upnp = UPNP.new()
	var err = upnp.discover()
	
	print("discover")
	
	if err != OK:
		push_error(str(err))
		emit_signal("upnp_completed", err)
		return

	var gateway = upnp.get_gateway()
	if gateway and gateway.is_valid_gateway():
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "UDP")
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "TCP")
		print("signal2")
		
		emit_signal("upnp_completed", OK)

func _ready():
	thread = Thread.new()
	thread.start(_upnp_setup.bind(SERVER_PORT))
	print("start")

func _exit_tree():
	# Wait for thread finish here to handle game exit while the thread is running.
	thread.wait_to_finish()

@rpc("any_peer", "reliable", "call_local")
func orderList():
	var new_list = []
	#lista_targets
	for val in list_targets:
		if val != null:
			new_list.append(val)
	list_targets = new_list.duplicate()
	new_list.clear()
	
	for val in main.party:
		if  val != null:
			new_list.append(val)
	main.party = new_list.duplicate()
	new_list.clear()
	
	for val in main.enemy_party:
		if  val != null:
			new_list.append(val)
	main.enemy_party = new_list.duplicate()
	new_list.clear()
	
	for val in main.turn_order:
		if  val != null:
			new_list.append(val)
	main.turn_order.clear()
	main.turn_order = new_list.duplicate()
