#NewMapIHope
#Meu plano é que esse seja um template pra um mapa
extends Node

#Nodes
onready var tilemap = get_node("TileMap")
onready var main 	= get_parent()

#Variáveis exportadas
export var layered_map = true

#Tamanho do mapa pra todas as camadas
export var map_size 			= Vector2(0,0)

#Spacing pra um player não ver o mapa dos outros players
export var spacing 				= 0

#Número de players nesse mapa
export var number_of_players 	= 0

#Active Player o número colocado aqui é o default
export var current_player 		= 0

#Variáveis
var cell_size

#Coisas pra inicializar o array de players
var players = []

#Sinais
signal map_bgm

func _ready():
	connect("map_bgm",main,"_on_NewMapIHope_map_bgm")
	emit_signal("map_bgm")
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
		players[current_player].active = false
		players[1].active = true
		current_player = 1
