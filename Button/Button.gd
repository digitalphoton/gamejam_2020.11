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
<<<<<<< Updated upstream:Button/Button.gd
<<<<<<< Updated upstream
var doorOn
=======
>>>>>>> Stashed changes

signal Button_Trigger
=======
var buttonOn

signal button_Trigger
>>>>>>> Stashed changes:Button/Middle.gd

# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(2048)
<<<<<<< Updated upstream:Button/Button.gd
<<<<<<< Updated upstream
	
func _process(_delta):
	if doorOn and y < y_dif/2:
		doorOn = false
		emit_signal("Button_Trigger", doorOn)
	if not doorOn and y > y_dif/2:
		doorOn = true
		emit_signal("Button_Trigger", doorOn)
=======


>>>>>>> Stashed changes
=======
	
func _process(_delta):
	if not buttonOn and y > y_dif/2:
		buttonOn = true
		emit_signal("button_Trigger", buttonOn)
	if buttonOn and y < y_dif/2:
		buttonOn = false
		emit_signal("button_Trigger", buttonOn)
>>>>>>> Stashed changes:Button/Middle.gd

func collision():
	is_colliding = false
	colliding_obj = []
	for body in A2D.get_overlapping_bodies():
		print(body)
		#Detecta se o objeto que colidiu pode ser movido
		if body.is_in_group("ButtonTriggers"):
			colliding_obj.append(body)
			is_colliding = true
	

<<<<<<< Updated upstream:Button/Button.gd
<<<<<<< Updated upstream
func _physics_process(_delta):
=======
func _physics_process(delta):
>>>>>>> Stashed changes
=======
func _physics_process(_delta):
>>>>>>> Stashed changes:Button/Middle.gd
	collision()
	if is_colliding and y < y_dif:
		self.position += Vector2(0, vel)
		y += vel
		for body in colliding_obj:
			body.position += Vector2(0, vel)
	if is_colliding == false and y > 0:
		self.position += Vector2(0, -vel)
		y += -vel


