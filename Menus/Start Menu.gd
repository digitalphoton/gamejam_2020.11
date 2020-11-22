#Start Menu.gd
extends Control

#Nodes
onready var main = get_parent()

func _ready():
	pass

func _on_START_pressed():
	main.change_scene(self,"res://Menus/Map_Select.tscn")

func _on_QUIT_pressed():
	get_tree().quit()
