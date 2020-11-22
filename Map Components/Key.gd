#Key.gd
extends RigidBody2D

#Variáveis exportadas
export(NodePath) var target_path

#Variáveis
var bodies
var target

#Sinais
signal unlock

func _ready():
	target = get_node(target_path)

func _process(_delta):
	bodies = get_colliding_bodies()
	
	if bodies != null:
		for i in bodies:
			if i == target:
				emit_signal("unlock")
				self.queue_free()
