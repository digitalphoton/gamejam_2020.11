#Key.gd
extends RigidBody2D

#Nodes
onready var main		= get_parent().get_parent()
onready var tilemap		= get_parent().get_node("TileMap")
onready var SFX_node	= main.get_node("SFX") 

#Variáveis exportadas
export(NodePath) var target_path
export var respawn_pos = Vector2(0,0)

#Variáveis
var bodies
var target
var grabbing = false
var player_node
var player_strength
var unlock_sound = "res://Sounds/door_open.wav"
var cell_size
var default_respawn_pos
var respawn = false

#Sinais
signal unlock

func _ready():
	self.set_can_sleep(false)
	target = get_node(target_path)
	cell_size = tilemap.cell_size.x
	default_respawn_pos = self.global_position

func _process(_delta):
	if grabbing:
		var force_dir = (player_node.global_position - self.global_position).normalized()
		self.apply_central_impulse(force_dir * player_strength)
	
	if Input.is_action_just_released("Pickup"):
		grabbing = false
	
	bodies = get_colliding_bodies()
	
	if bodies != null:
		for i in bodies:
			if i == target:
				SFX_node.stream = load(unlock_sound)
				SFX_node.play()
				
				emit_signal("unlock")
				self.queue_free()

func _integrate_forces(state):
	if respawn:
		if respawn_pos == Vector2(0,0):
			state.transform = Transform2D(0,default_respawn_pos)
		else:
			state.transform = Transform2D(0,(respawn_pos * cell_size) + (Vector2(cell_size / 2, cell_size * 3 / 4)))
		state.linear_velocity = Vector2()
		respawn = false

func _on_Button_button_Trigger(buttonOn):
	if buttonOn:
		respawn = true

func grabbed(node_path,strength):
	player_node = get_node(node_path)
	player_strength = strength
	grabbing = true

func released():
	grabbing = false
