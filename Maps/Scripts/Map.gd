#Map
#Meu plano é que esse seja um template pra um mapa
extends Node

#Nodes
onready var tilemap 	= get_node("TileMap")
onready var main 		= get_parent()
onready var BGM_node	= main.get_node("BGM")

#Variáveis exportadas
export var layered_map = true

#Caminho pro arquivo desse mapa
export(String,FILE,"*.tscn") var current_map_path

#Tamanho do mapa pra todas as camadas
export var map_size 			= Vector2(0,0)

#Spacing pra um player não ver o mapa dos outros players
export var spacing 				= 0

#Número de players nesse mapa
export var number_of_players 	= 0

#Active Player o número colocado aqui é o default
export var current_player 		= 0

#Música do mapa
export(String,FILE,"*.ogg") var bgm

#Variáveis
var cell_size

#Coisas pra inicializar o array de players
var players = []

func _ready():
	#Toca a BGM
	if BGM_node.stream != load(bgm):
		BGM_node.stream = load(bgm)
		BGM_node.play()
	
	#Pega o tamanho das células do tilemap, yes i know they're gonna remain as 256x256 but screw it
	cell_size = tilemap.cell_size.x
	
	#Inicializa o array de players
	#Devido a como isso tá setado os players vão sempre ter que ser as primeiras childs
	players.resize(number_of_players)
	
	#Escolhe o modo de inicialização dependendo se o mapa tá em camadas ou não, o padrão aqui é que as camadas estão uma em cima da outra no eixo y
	if layered_map:
		for i in range(number_of_players):
			players[i] = get_child(i)
			
			#Automaticamente seta os limites das cameras
			players[i].set_camlimits(0,0,(cell_size * (map_size.x + 1)),(cell_size * (map_size.y + 1) * i) + (cell_size * (map_size.y + 1)) + (cell_size * spacing * i))
	else:
		for i in range(number_of_players):
			players[i] = get_child(i)
			
			#Automaticamente seta os limites das cameras
			players[i].set_camlimits(0,0,(cell_size * (map_size.x + 1)),(cell_size * (map_size.y + 1)))
	
	#Ativa o player default
	players[current_player].active = true

func _process(_delta):
	
	#Coisas pra selecionar o player
	if Input.is_action_just_pressed("Select Player 1"):
		players[current_player].active = false
		players[0].active = true
		current_player = 0
	elif Input.is_action_just_pressed("Select Player 2"):
		if number_of_players > 1:
			players[current_player].active = false
			players[1].active = true
			current_player = 1
	elif Input.is_action_just_pressed("Select Player 3"):
		if number_of_players > 2:
			players[current_player].active = false
			players[2].active = true
			current_player = 2
	elif Input.is_action_just_pressed("Select Player 4"):
		if number_of_players > 3:
			players[current_player].active = false
			players[3].active = true
			current_player = 3

func retry():
	main.change_scene(self,current_map_path)

func _on_Goal_victory():
	main.change_scene(self,"res://Menus/VictoryScene.tscn")
