extends Node

var rng = RandomNumberGenerator.new() #Settear seed en main

const BOSS = preload("res://scenes/units/enemies/boss.tscn")
const ENEMIGO = preload("res://scenes/units/enemies/enemigo.tscn")
const MEDIC = preload("res://scenes/units/enemies/medic.tscn")
const PYRO = preload("res://scenes/units/enemies/pyro.tscn")
const WARLOCK = preload("res://scenes/units/enemies/warlock.tscn")
const SLUGGER = preload("res://scenes/units/enemies/slugger.tscn")

const Team1 = [PYRO, ENEMIGO, ENEMIGO, PYRO]
const Team2 = [ENEMIGO, MEDIC, MEDIC, ENEMIGO]
const Team3 = [ENEMIGO, PYRO,  WARLOCK, ENEMIGO]
const Team4 = [WARLOCK, ENEMIGO,  ENEMIGO, WARLOCK]
const Team5 = [PYRO, SLUGGER, SLUGGER, PYRO]
const TeamDummy = [SLUGGER, SLUGGER, SLUGGER]

var Teams = [Team1, Team5]
#var Teams = [TeamDummy]

var bossTeam = [ENEMIGO, WARLOCK, BOSS, WARLOCK, MEDIC]
var bossTeamDummy = [MEDIC]

var Boss_teams = [bossTeam]

func get_team():
	var index = rng.randi_range(0, Teams.size() - 1)
	if Teams.is_empty():
		return null
	else:
		return Teams.pop_at(index)

func get_boss():
	var index = rng.randi_range(0, Boss_teams.size() - 1)
	if Boss_teams.is_empty():
		return null
	else:
		return Boss_teams.pop_at(index)
