extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var plat1 = get_node("platform1")
onready var plat2 = get_node("platform2")
onready var plat1_roofpointr = get_node("platform1/roofpointr")
onready var plat1_roofpointl = get_node("platform1/roofpointl")
onready var plat2_roofpointr = get_node("platform2/roofpointr")
onready var plat2_roofpointl = get_node("platform2/roofpointl")
onready var plat1_roper = get_node("platform1/rightrope")
onready var plat1_ropel = get_node("platform1/leftrope")
onready var plat2_roper = get_node("platform2/rightrope")
onready var plat2_ropel = get_node("platform2/leftrope")
onready var plat1_sprite = get_node("platform1/Sprite")
onready var plat2_sprite = get_node("platform2/Sprite")
onready var plat1_collision = get_node("platform1/CollisionShape2D")
onready var plat1_floor_collision = get_node("platform1/Area2Dplat1/CollisionShape2D")
onready var plat2_collision = get_node("platform2/CollisionShape2D")
onready var plat2_floor_collision = get_node("platform2/Area2Dplat2/CollisionShape2D")
onready var plat1_upper_limit = get_node("platform1 upper limit")
onready var plat1_lower_limit = get_node("platform1 lower limit")
onready var plat2_upper_limit = get_node("platform2 upper limit")
onready var plat2_lower_limit = get_node("platform2 lower limit")

export var player_mass = 1.5
export var speed_modifier = 500

var total_mass_plat1 = 0
var total_mass_plat2 = 0
var result_move = 0

var plat1_init_x_pos = 0
var plat2_init_x_pos = 0

var plat1_transformed_texture
var plat2_transformed_texture

var bodies

# Called when the node enters the scene tree for the first time.
func _ready():
	plat1_init_x_pos = plat1.get_position().x
	plat2_init_x_pos = plat2.get_position().x
	
	#Muda os tamanhos das colisões pra encaixar com o sprite transformado
	plat1_transformed_texture = plat1_sprite.texture.get_size() * (plat1_sprite.transform.x + plat1_sprite.transform.y)
	plat1_collision.shape.extents = Vector2(plat1_transformed_texture / 2)
	plat1_floor_collision.position = Vector2(0,-(plat1_transformed_texture.y / 2))
	plat1_floor_collision.shape.extents = Vector2(plat1_transformed_texture.x / 2,16)
	plat2_transformed_texture = plat2_sprite.texture.get_size() * (plat2_sprite.transform.x + plat2_sprite.transform.y)
	plat2_collision.shape.extents = Vector2(plat2_transformed_texture / 2)
	plat2_floor_collision.position = Vector2(0,-(plat2_transformed_texture.y / 2))
	plat2_floor_collision.shape.extents = Vector2(plat2_transformed_texture.x / 2,16)
	
	#Conecta as cordas na plataforma
	plat1_roofpointr.position = Vector2((plat1_transformed_texture.x / 2) - 32,0)
	plat1_roper.points[0] = plat1_roofpointr.position
	plat1_roofpointl.position = Vector2(-((plat1_transformed_texture.x / 2) - 32),0)
	plat1_ropel.points[0] = plat1_roofpointl.position
	plat2_roofpointr.position = Vector2((plat2_transformed_texture.x / 2) - 32,0)
	plat2_roper.points[0] = plat2_roofpointr.position
	plat2_roofpointl.position = Vector2(-((plat2_transformed_texture.x / 2) - 32),0)
	plat2_ropel.points[0] = plat2_roofpointl.position

func _process(_delta):
	#Mantem conecta as cordas no teto
	plat1_roper.points[1] = plat1.to_local(plat1_roofpointr.get_collision_point())
	plat1_ropel.points[1] = plat1.to_local(plat1_roofpointl.get_collision_point())
	plat2_roper.points[1] = plat2.to_local(plat2_roofpointr.get_collision_point())
	plat2_ropel.points[1] = plat2.to_local(plat2_roofpointl.get_collision_point())

func _physics_process(delta):
	if !plat1.get_position().x == plat1_init_x_pos:
		plat1.position.x = plat1_init_x_pos
	if !plat2.get_position().x == plat2_init_x_pos:
		plat2.position.x = plat2_init_x_pos
	
	#verifica se houveram colisões
	result_move = total_mass_plat1 - total_mass_plat2
	
	if plat1.get_global_position().y + (result_move * speed_modifier * delta) > plat1_lower_limit.get_global_position().y or plat1.get_global_position().y + (result_move * speed_modifier * delta) < plat1_upper_limit.get_global_position().y or plat2.get_global_position().y - (result_move * speed_modifier * delta) > plat2_lower_limit.get_global_position().y or plat2.get_global_position().y - (result_move * speed_modifier * delta) < plat2_upper_limit.get_global_position().y:
		result_move = 0
	
	bodies = get_node("platform1/Area2Dplat1").get_overlapping_bodies()
	
	for i in bodies:
		if i.is_in_group("Player"):
			i.move_and_slide(Vector2(0,result_move*speed_modifier),Vector2(0,-1))
	
	bodies = get_node("platform2/Area2Dplat2").get_overlapping_bodies()
	
	for i in bodies:
		if i.is_in_group("Player"):
			i.move_and_slide(Vector2(0,-result_move*speed_modifier),Vector2(0,-1))
	
	plat1.move_and_slide(Vector2(0,result_move*speed_modifier))
	plat2.move_and_slide(Vector2(0,-result_move*speed_modifier))

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
