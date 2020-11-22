#Map_Select.gd
tool
extends Control

#Nodes
onready var button_container = get_node("MarginContainer/VBoxContainer/VBoxContainer")
onready var main = self.get_parent()

#Variáveis exportáveis
export var maps = []

#Variáveis
var n_maps

func _ready():
	n_maps = maps.size()

func _process(_delta):
	print("Hello!")
	if Input.is_action_just_pressed("ui_cancel"):
		main.change_scene(main.get_child(0),"res://Menus/Start Menu.tscn")

func _on_DebugMap_pressed():
	main.change_scene(self,maps[0])


func _on_NewMapIHope_pressed():
	main.change_scene(self,maps[1])
