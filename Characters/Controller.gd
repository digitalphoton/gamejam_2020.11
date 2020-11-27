#controller.gd
#Parente tem que ser KinematicBody2D
extends Node

#Scenes
onready var death_scene = preload("res://Menus/DeathScene.tscn")

#Variáveis constantes
const RIGHT = Vector2(1,0)
const LEFT 	= Vector2(-1,0)
const DOWN 	= Vector2(0,1)
const UP 	= Vector2(0,-1)

#Variáveis editáveis no Inspector
#export var acceleration = 58
export var speed = 600
export var jump_height = 1600
export var max_falling_speed = 600

#Variáveis
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var motion = Vector2()
var input_enabled = true

#Node
onready var kb = self.get_parent()

func _ready():
	pass

func move(input_right,input_left,input_jump):
	#Verifica se o parente é do tipo exigido
	if verify() == false:
		print("Parent is invalid! Parent must be KinematicBody2D")
		return 0
	
	if !kb.is_on_floor():
		#Gravity power engage!
		motion.y += gravity
		#Limita o poder da gravidade :C
		motion.y = min(max_falling_speed,motion.y)
	
	#Checa se o input tá habilitado
	if input_enabled == true:
		#Pro movimento horizontal
		if input_right == true and input_left == true:
			motion.x = lerp(motion.x,0,0.4)
		elif input_right == true:
			motion.x = speed
		elif input_left == true:
			motion.x = -speed
		else:
			motion.x = lerp(motion.x,0,0.4)
		
		#Pra pular
		if kb.is_on_floor() and input_jump == true:
			motion.y = -jump_height
	else:
		motion.x = lerp(motion.x,0,0.2)
	
	#Executa o movimento
	if input_jump == true or kb.is_on_wall():
		motion = kb.move_and_slide(motion,UP,false,4,0.785398,false)
	else:
		motion = kb.move_and_slide_with_snap(motion,Vector2(0,gravity),UP,false,4,0.785398,false)

func verify():
	if kb.is_class("KinematicBody2D"):
		return true
	else:
		print("Failed to verify")
		return false
