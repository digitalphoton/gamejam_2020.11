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
export var acceleration = 350
export var max_speed = 2000
export var jump_height = 4000
export var gravity = 200
export var max_falling_speed = 2000

#Variáveis
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
	
	#Gravity power engage!
	if !kb.is_on_floor():
		motion.y += gravity
		#Limita o poder da gravidade :C
		motion.y = min(max_falling_speed,motion.y)
	
	#Checa se o input tá habilitado
	if input_enabled == true:
		#Pro movimento horizontal
		if input_right == true and input_left == true:
			motion.x = lerp(motion.x,0,0.4)
		elif input_right == true:
			motion.x += acceleration
			motion.x = min(max_speed,motion.x)
		elif input_left == true:
			motion.x -= acceleration
			motion.x = max(-max_speed,motion.x)
		else:
			motion.x = lerp(motion.x,0,0.4)
		
		#Pra pular
		if kb.is_on_floor() and input_jump == true:
			motion.y = -jump_height
	else:
		motion.x = lerp(motion.x,0,0.2)
	
	#Executa o movimento
	motion = kb.move_and_slide(motion,UP,false,4,0.785398,false)

func verify():
	if kb.is_class("KinematicBody2D"):
		return true
	else:
		print("Failed to verify")
		return false
