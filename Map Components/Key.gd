#Key.gd
extends RigidBody2D

#Variáveis exportadas
export(NodePath) var target

#Variáveis
var bodies
var target_id

#Sinais
signal unlock

func _ready():
	target_id = target.get_object_id()

func _process(delta):
	bodies = get_colliding_bodies()
	
	if bodies != null:
		for i in bodies:
			if i.get_object_id() == target_id:
				emit_signal("unlock")
				self.queue_free()
