#Player.gc
extends KinematicBody2D

#Variáveis exportáveis
export(String,FILE,"*.tscn") var spawn_scene_path
export var spawn_coordinates = Vector2()

#Variáveis
var player_input = {}

#Nodes
onready var controller = get_node("Controller")

func _ready():
	pass

func _process(delta):
	#Player controls. Teclas podem ser encontradas em Project>>Project Settings>>Input Map
	player_input.right = Input.is_action_pressed("Right")
	player_input.left = Input.is_action_pressed("Left")
	player_input.jump = Input.is_action_pressed("Jump")
	
	#Look at deez moves moving
	controller.move(player_input.right,player_input.left,player_input.jump)
<<<<<<< Updated upstream
=======
	
	#Detecta colisões com corpos
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var body = collision.collider
		
		#Detecta se o objeto que colidiu pode ser movido
		if body.is_in_group("MovableObjects"):
			
			#Use a força!
			var force_dir = Vector2(body.global_position - self.global_position).normalized()
			body.apply_impulse(Vector2(0, 64), force_dir * strength)
			
>>>>>>> Stashed changes
