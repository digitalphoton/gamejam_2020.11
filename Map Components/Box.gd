#Box.gd
extends RigidBody2D

#Variáveis exportadas
export var respawn_pos = Vector2()

#Nodes
onready var tilemap = get_parent().get_node("TileMap")

#Variáveis
var cell_size
var respawn = false

func _ready():
	cell_size = tilemap.cell_size.x

func _integrate_forces(state):
	if respawn:
		state.transform = Transform2D(0,(respawn_pos * cell_size) + (Vector2(cell_size / 2, cell_size / 2)))
		state.linear_velocity = Vector2()
		respawn = false

func _on_Button_button_Trigger(buttonOn):
	if buttonOn:
		respawn = true
