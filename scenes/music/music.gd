extends Node

#Nodo que tendra la musica
@onready var music = $Soundtrack 
@export var menu: AudioStream
@export var battlemusic: AudioStream
@export var bossmusic: AudioStream
@export var endgameMusic: AudioStream
# Called when the node enters the scene tree for the first time.
func _ready():
	music.connect("finished", loopMusic)

func playMenu():
	music.stream = menu
	music.play()

func pauseMusic():
	music.stop()

func playmusicBattle():
	music.stream = battlemusic
	music.play()
	
func playBossMusic():
	music.stream = bossmusic
	music.play()

func loopMusic():
	music.play()

func playEndGameMusic():
	music.stream = endgameMusic
	music.disconnect("finished",loopMusic)
	music.play()
