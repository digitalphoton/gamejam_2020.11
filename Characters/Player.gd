#Player.gc
extends KinematicBody2D

#Variáveis exportáveis
#Stats

export var active = false
export var strength = 100
export var camlimits = {"Left":-10000000,"Top":-10000000,"Right":10000000,"Bottom":10000000}


#Respawn Data
export(String,FILE,"*.tscn") var spawn_scene_path
export var spawn_coordinates = Vector2()

#Variáveis
var player_input = {}
var dead = false

#Nodes
onready var controller 	= get_node("Controller")
onready var camera 		= get_node("Camera2D")
onready var sprite		= get_node("Sprite")
onready var raycast		= get_node("RayCast2D")

func _ready():
	pass

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
	
	#Look at deez moves moving
	controller.move(player_input.right,player_input.left,player_input.jump)
	
	#Detecta colisões com corpos
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var body = collision.collider
		
		#Detecta se o corpo existe
		if body != null:
			
		#Detecta se o objeto que colidiu pode ser movido e como deve ser movido
			if body.is_in_group("MovableObjects"):
				var collision_point
				var force_offset
				
				#Seta o ponto final do raycast que é basicamente uma seta que reporta a colisão que acontecer mais perto da sua origem
				raycast.set_cast_to(body.global_position - self.global_position)
				
				#Pega o ponto de colisão entre o player e o objeto
				collision_point = raycast.get_collision_point()
				
				#Seta o offset do impulso a ser aplicado + a direção
				force_offset = collision_point - body.get_global_position()
				var force_dir = Vector2(collision_point - self.global_position).normalized()
				
				#Use a força!
				body.apply_impulse(force_offset,force_dir * strength)
			
			#Mesma coisa só que pra plataformas giratórias que eu tive que setar só o eixo y do destino do raycast enquanto o anterior setava no centro do corpo que colidiu
			elif body.is_in_group("RotatingPlatforms"):
				var collision_point
				var force_offset
				
				raycast.set_cast_to(Vector2(0,body.global_position.y - self.global_position.y))
				collision_point = raycast.get_collision_point()
				
				force_offset = collision_point - body.get_global_position()
				var force_dir = Vector2(collision_point - self.global_position).normalized()
				
				#Use a força!
				body.apply_impulse(force_offset,force_dir * strength)

func set_camlimits(left = -10000000,top = -10000000,right = 10000000,bottom = 10000000):
	camera.limit_left 	= left
	camera.limit_top 	= top
	camera.limit_right 	= right
	camera.limit_bottom = bottom

func kill():
	sprite.set_flip_v(true)
	dead = true
	print("killed!")
