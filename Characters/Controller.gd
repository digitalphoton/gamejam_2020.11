#controller.gd
#Parente tem que ser KinematicBody2D
extends Node

#Variáveis constantes
const RIGHT = Vector2(1,0)
const LEFT 	= Vector2(-1,0)
const DOWN 	= Vector2(0,1)
const UP 	= Vector2(0,-1)

#Variáveis editáveis no Inspector
export var acceleration = 350
export var max_speed = 2000
export var jump_height = 3500
export var gravity = 200
export var max_falling_speed = 2000

#Variáveis
var velocity = Vector2()
var input_disabled = false

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
		velocity.y += gravity
		
		#Limita o poder da gravidade :C
		velocity.y = min(max_falling_speed,velocity.y)
	
	#Checa se o input tá habilitado
	if input_disabled == true:
		pass
	else:
		#Pro movimento horizontal
		if input_right == true and input_left == true:
			velocity.x = lerp(velocity.x,0,0.4)
		elif input_right == true:
			velocity.x += acceleration
			velocity.x = min(max_speed,velocity.x)
		elif input_left == true:
			velocity.x -= acceleration
			velocity.x = max(-max_speed,velocity.x)
		else:
			velocity.x = lerp(velocity.x,0,0.4)
		
		#Pra pular
		if kb.is_on_floor() and input_jump == true:
			velocity.y = -jump_height
		
		#Executa o movimento
		velocity = kb.move_and_slide(velocity,UP)

func verify():
	if kb.is_class("KinematicBody2D"):
		return true
	else:
		print("Failed to verify")
		return false
