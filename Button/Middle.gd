extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var y = 0
export var y_dif = 16
var is_colliding
var colliding_obj
export var vel = 2
onready var A2D = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(2048)

func collision():
	is_colliding = false
	colliding_obj = []
	for body in A2D.get_overlapping_bodies():
		#Detecta se o objeto que colidiu pode ser movido
		if body.is_in_group("MovableObjects"):
			colliding_obj.append(body)
			is_colliding = true
	

func _physics_process(delta):
	collision()
	if is_colliding and y < y_dif:
		self.position += Vector2(0, vel)
		y += vel
		for body in colliding_obj:
			body.position += Vector2(0, vel)
	if is_colliding == false and y > 0:
		self.position += Vector2(0, -vel)
		y += -vel


