#Goal.gd
extends Area2D

#Nodes
onready var map = get_parent()

#Variáveis
var number_of_players
var number_of_players_on_goal	= 0

signal victory

func _ready():
	number_of_players = map.number_of_players
	
	connect("victory",map,"_on_Goal_victory")

func _process(_delta):
	if number_of_players_on_goal == number_of_players:
		emit_signal("victory")

func _on_Goal_body_entered(body):
	if body.is_in_group("Player"):
		number_of_players_on_goal += 1

func _on_Goal_body_exited(body):
	if body.is_in_group("Player"):
		number_of_players_on_goal -= 1
