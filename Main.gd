#Main
extends Node

#Nodes
onready var yamada 	= get_node("Yamada")
onready var su 		= get_node("Su")

#Variáveis
#Coisas pra inicializar o array de players
var players = []
var number_of_players 	= 2

#Active Player
var current_player 		= 0

func _ready():
	#Inicializa o array de players
	players.resize(number_of_players)
	players = [yamada,su]
	players[current_player].active = true

func _process(_delta):
	
	#Coisas pra selecionar o player
	if Input.is_action_just_pressed("Select Player 1"):
		players[current_player].active = false
		players[0].active = true
		current_player = 0
	elif Input.is_action_just_pressed("Select Player 2"):
		players[current_player].active = false
		players[1].active = true
		current_player = 1
