#Key.gd
extends RigidBody2D

#Nodes
onready var main		= get_parent().get_parent()
onready var SFX_node	= main.get_node("SFX") 

#Variáveis exportadas
export(NodePath) var target_path

#Variáveis
var bodies
var target
var grabbed = false
var player_node
var player_strength
var unlock_sound = "res://Sounds/door_open.ogg"

#Sinais
signal unlock

func _ready():
	self.set_can_sleep(false)
	target = get_node(target_path)

func _process(_delta):
	if grabbed:
		var force_dir = (player_node.global_position - self.global_position).normalized()
		self.apply_central_impulse(force_dir * player_strength)
	
	if Input.is_action_just_released("Pickup"):
		grabbed = false
	
	bodies = get_colliding_bodies()
	
	if bodies != null:
		for i in bodies:
			if i == target:
				SFX_node.stream = load(unlock_sound)
				SFX_node.play()
				
				emit_signal("unlock")
				self.queue_free()

func grabbed(node_path,strength):
	player_node = get_node(node_path)
	player_strength = strength
	grabbed = true

func released():
	grabbed = false
