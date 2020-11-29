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
var SFX = {"Jump":"res://Sounds/jump.wav","KeyGrab":"res://Sounds/key_grab.wav"}

#Nodes
onready var main			= get_parent().get_parent()
onready var current_map 	= main.get_child(main.get_child_count() - 1)
onready var canvas_layer	= current_map.get_node("CanvasLayer")
onready var SFX_node		= main.get_node("SFX")

onready var controller 	= get_node("Controller")
onready var camera 		= get_node("Camera2D")
onready var sprite		= get_node("AnimatedSprite")
onready var grabarea	= get_node("GrabArea")
onready var floorcheck	= get_node("FloorCheck")

#Scenes
onready var death_scene = preload("res://Menus/DeathScene.tscn")

func _ready():
	pass

func _process(_delta):
	#Tela de morte
	if active:
		if Input.is_action_just_pressed("Retry"):
			current_map.retry()
	
		#Voltar para o menu
		if Input.is_action_just_pressed("ui_cancel"):
			main.change_scene(main.get_child(main.get_child_count() - 1),"res://Menus/MapSelect.tscn")

func _physics_process(_delta):
	if active:
		camera.current = true
		if !dead:
			controller.input_enabled = true

			#Player controls. Teclas podem ser encontradas em Project>>Project Settings>>Input Map
			player_input.right = Input.is_action_pressed("Right")
			player_input.left = Input.is_action_pressed("Left")
			player_input.jump = Input.is_action_pressed("Jump")
			player_input.pickup = Input.is_action_pressed("Pickup")
			
			#Gráficos
			#This piece of code is kinda confusing so here's the gist of it:
			#1: Player está no chão?
			#Sim -> 2
			#Não -> Toca a animação de Jump
			#
			#2: Player está encostando em alguma parede?
			#Sim -> 4
			#Não -> 3
			#
			#3: Player está apertando pra direita ou pra esquerda?
			#Sim -> Toca a animação de run
			#Não -> Toca a animação de idle
			#
			#4: Player está encostando em um objeto movível ou uma parede estática?
			#Objeto Movível		-> 3 (yes this part is gonna be another piece of code that's pretty much the same as the code for 3)
			#Parede Estática 	-> Toca a animação de idle
			
			#Testa se o player está no chão, precisa ser essa função pq o is_on_floor é exato demais e o player ficaria tendo convulsões na hora de descer nas plataformas das polias
			if test_move(self.transform,Vector2(0,controller.gravity),false):
				#Gráficos
				#Testa se o player bateu numa parede
				#Se sim toca a animação idle
				if self.is_on_wall():
					#Testa se o player bateu num objeto movível ao invés de uma parede
					for i in get_slide_count():
						var collision = get_slide_collision(i)
						var body = collision.collider
						#Detecta se o objeto que colidiu pode ser movido
						if body.is_in_group("MovableObjects"):
							if player_input.right or player_input.left:
								sprite.play("run")
						else:
							sprite.play("idle")
				#Se não toca as animações normalmente
				else:
					#Toca run quando o player vai pra direita ou pra esquerda
					if player_input.right or player_input.left:
						sprite.play("run")
					#Toca idle quando o player não toca nada, yes there are two play idles screw it okay
					else:
						sprite.play("idle")
			#Gráficos de pulo
			elif sprite.get_animation() != "jump":
				sprite.play("jump")
			
			#Seta a direção do gráfico
			if player_input.right:
				sprite.set_flip_h(false)
			elif player_input.left:
				sprite.set_flip_h(true)
			
			#Sons
			#Som de pulo
			if self.is_on_floor() and player_input.jump:
				SFX_node.stream = load(SFX.Jump)
				SFX_node.play()
			
			#Detecta colisões com corpos
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				var body = collision.collider
				#Detecta se o objeto que colidiu pode ser movido
				if body.is_in_group("MovableObjects"):
					#Checa se o player está pisando em cima de uma caixa
					bodies = floorcheck.get_overlapping_bodies()
					
					#Se o player não estiver pisando em cima da caixa exerce a força sobre a caixa
					if bodies != null:
						for j in bodies:
							if !j.is_in_group("MovableObjects"):
								#Use a força!
								var force_dir = (body.global_position - self.global_position).normalized()
								body.apply_central_impulse(force_dir * strength)
			
			#Detecta os corpos dentro da área de força
			bodies = grabarea.get_overlapping_bodies()
			
			if bodies != null:
				for i in bodies:
					if i.is_in_group("Items"):
						#Som de pegar items
						if Input.is_action_just_pressed("Pickup"):
							SFX_node.stream = load(SFX.KeyGrab)
							SFX_node.play()
							i.grabbed(self.get_path(),strength)
			
			#Look at deez moves moving
			controller.move(player_input.right,player_input.left,player_input.jump)
		else:
			controller.input_enabled = false
			
			#Look at deez moves not moving
			controller.move(false,false,false)
	else:
		camera.current = false
		
		#Look at deez moves not moving
		controller.move(false,false,false)

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
