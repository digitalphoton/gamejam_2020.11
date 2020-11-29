#Box.gd
extends RigidBody2D

#Variáveis exportadas
export var respawn_pos = Vector2()

#Nodes
onready var tilemap 	= get_parent().get_node("TileMap")
onready var sprite		= get_node("Sprite")
onready var collision 	= get_node("CollisionShape2D")

#Variáveis
var default_respawn_pos
var cell_size
var respawn = false

var transformed_sprite_size

func _ready():
	cell_size = tilemap.cell_size.x
	default_respawn_pos = self.global_position
	
	transformed_sprite_size = sprite.texture.get_size() * (sprite.transform.x + sprite.transform.y)
	collision.shape.extents = transformed_sprite_size / 2

func _integrate_forces(state):
	if respawn:
		if respawn_pos == Vector2(0,0):
			state.transform = Transform2D(0,default_respawn_pos)
		else:
			state.transform = Transform2D(0,(respawn_pos * cell_size) + (Vector2(cell_size / 2, cell_size / 2)))
		state.linear_velocity = Vector2()
		respawn = false

func _on_Button_button_Trigger(buttonOn):
	if buttonOn:
		respawn = true
