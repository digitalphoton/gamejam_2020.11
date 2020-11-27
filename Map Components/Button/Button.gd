extends Node2D


#Nodes
onready var A2D 	= get_node("PushButton/Area2D")
onready var PushButton 	= get_node("PushButton")

onready var main 		= get_parent().get_parent()
onready var SFX_node 	= main.get_node("SFX")

#Variáveis exportadas
export var y_dif = 12
export var vel = 2

#Variáveis
var y = 0
var is_colliding
var colliding_obj
var buttonOn = false

var buttonOn_sound = "res://Sounds/button_press.ogg"

#Sinais
signal button_Trigger

# Called when the node enters the scene tree for the first time.
func _ready():
	PushButton.set_contact_monitor(true)
	PushButton.set_max_contacts_reported(10)
	
func _process(_delta):
	if not buttonOn and y > y_dif/2:
		SFX_node.stream = load(buttonOn_sound)
		SFX_node.play()
		
		buttonOn = true
		emit_signal("button_Trigger", buttonOn)
	if buttonOn and y < y_dif/2:
		buttonOn = false
		emit_signal("button_Trigger", buttonOn)

func collision():
	is_colliding = false
	colliding_obj = []
	for body in A2D.get_overlapping_bodies():
		#Detecta se o objeto que colidiu pode ser movido
		if body.is_in_group("ButtonTriggers"):
			colliding_obj.append(body)
			is_colliding = true

func _physics_process(_delta):
	collision()
	if is_colliding and y < y_dif:
		PushButton.position += Vector2(0, vel)
		y += vel
		for body in colliding_obj:
			body.position += Vector2(0, vel)
	if is_colliding == false and y > 0:
		PushButton.position += Vector2(0, -vel)
		y += -vel


