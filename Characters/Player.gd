#Player.gc
extends KinematicBody2D

#Variáveis exportáveis
#Stats

export var active = false
export var strength = 300
export var camlimits = {"Left":-10000000,"Top":-10000000,"Right":10000000,"Bottom":10000000}

#Variáveis
var player_input = {}
var dead = false
var bodies

#Efeitos Sonóros
var SFX = {"Jump":"res://Sounds/jump.ogg","KeyGrab":"res://Sounds/key_grab.ogg"}

#Nodes
onready var main			= get_parent().get_parent()
onready var current_map 	= main.get_child(main.get_child_count() - 1)
onready var canvas_layer	= current_map.get_node("CanvasLayer")
onready var SFX_node		= main.get_node("SFX")

onready var controller 	= get_node("Controller")
onready var camera 		= get_node("Camera2D")
onready var sprite		= get_node("Sprite")
onready var area		= get_node("Area2D")

#Scenes
onready var death_scene = preload("res://Menus/DeathScene.tscn")

func _ready():
	pass

func _process(_delta):
	#Tela de morte
	if dead and Input.is_action_just_pressed("Jump"):
		current_map.retry()
	
	#Voltar para o menu
	if active == true and Input.is_action_just_pressed("ui_cancel"):
		main.change_scene(main.get_child(main.get_child_count() - 1),"res://Menus/MapSelect.tscn")

func _physics_process(_delta):
	#Muda o current da camera de acordo com a var active
	#Ou seja, quando o active é true a câmera desse personagem é usada quando o active é false a camera desse personagem não é usada
	if camera.current != active:
		camera.current = active
	if dead == false:
		if controller.input_enabled != active:
			controller.input_enabled = active
	else:
		controller.input_enabled	= false

	#Player controls. Teclas podem ser encontradas em Project>>Project Settings>>Input Map
	player_input.right = Input.is_action_pressed("Right")
	player_input.left = Input.is_action_pressed("Left")
	player_input.jump = Input.is_action_pressed("Jump")
	
	player_input.pickup = Input.is_action_pressed("Pickup")
	
	if self.is_on_floor() and player_input.jump:
		if active and !dead:
			SFX_node.stream = load(SFX.Jump)
			SFX_node.play()
	
	#Look at deez moves moving
	controller.move(player_input.right,player_input.left,player_input.jump)
	
	#Detecta colisões com corpos
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var body = collision.collider
		
		#Detecta se o objeto que colidiu pode ser movido
		if body.is_in_group("MovableObjects"):
			
			#Use a força!
			var force_dir = Vector2(body.global_position - self.global_position).normalized()
			body.apply_central_impulse(force_dir * strength)
	
	bodies = area.get_overlapping_bodies()
	
	if bodies != null:
		for i in bodies:
			if i.is_in_group("Items"):
				if !dead:
					if Input.is_action_just_pressed("Pickup"):
						if active:
							SFX_node.stream = load(SFX.KeyGrab)
							SFX_node.play()
					
					if player_input.pickup and active:
						var force_dir = (self.get_global_position() - i.get_global_position()).normalized()
						i.apply_central_impulse(force_dir * strength)

func set_camlimits(left = -10000000,top = -10000000,right = 10000000,bottom = 10000000):
	camera.limit_left 	= left
	camera.limit_top 	= top
	camera.limit_right 	= right
	camera.limit_bottom = bottom

func kill():
	sprite.set_flip_v(true)
	dead = true
	var death_window = death_scene.instance()
	canvas_layer.add_child(death_window)
