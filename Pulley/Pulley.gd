extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var plat1 = get_node("platform1")
onready var plat2 = get_node("platform2")

export var player_mass = 1.5
export var speed_modifier = 500

var total_mass_plat1 = 0
var total_mass_plat2 = 0
var result_move = 0
var flag = 0

var plat1_init_x_pos = 0
var plat2_init_x_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	plat1_init_x_pos = plat1.get_position().x
	plat2_init_x_pos = plat2.get_position().x
	pass # Replace with function body.

func _physics_process(_delta):
	if !plat1.get_position().x == plat1_init_x_pos:
		plat1.position.x = plat1_init_x_pos
	if !plat2.get_position().x == plat2_init_x_pos:
		plat2.position.x = plat2_init_x_pos
	#verifica se houveram colisões
	result_move = total_mass_plat1 - total_mass_plat2
	if flag == 1:
		if result_move >= 0:
#			print("plat1 must down")
			result_move = 0
	elif flag == 2:
		if result_move <= 0:
#			print("plat1 must up")
			result_move = 0
		
	plat1.move_and_slide(Vector2(0, result_move*speed_modifier),Vector2(0, -1))
	plat2.move_and_slide(Vector2(0, -result_move*speed_modifier),Vector2(0, -1))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2Dplat1_body_entered(body):
	if body.is_in_group("MovableObjects"):
		total_mass_plat1 += body.mass
	if body.is_in_group("Player"):
		total_mass_plat1 += player_mass

func _on_Area2Dplat2_body_entered(body):
	if body.is_in_group("MovableObjects"):
		total_mass_plat2 += body.mass
	if body.is_in_group("Player"):
		total_mass_plat2 += player_mass


func _on_Area2Dplat1_body_exited(body):
	if body.is_in_group("MovableObjects"):
		total_mass_plat1 -= body.mass
	if body.is_in_group("Player"):
		total_mass_plat1 -= player_mass


func _on_Area2Dplat2_body_exited(body):
	if body.is_in_group("MovableObjects"):
		total_mass_plat2 -= body.mass
	if body.is_in_group("Player"):
		total_mass_plat2 -= player_mass


func _on_Limiter_body_exited(body):
	if body == get_node("platform1") or body == get_node("platform2"):
		if result_move >= 0:
			flag = 1
		else:
			flag = 2

func _on_Limiter_body_entered(body):
	if body == get_node("platform1") or body == get_node("platform2"):
		flag = 0
