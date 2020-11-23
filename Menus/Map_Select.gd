#Map_Select.gd
tool
extends Control

#Nodes
onready var button_container = get_node("MarginContainer/VBoxContainer/VBoxContainer")
onready var main = self.get_parent()
onready var SFX_node = main.get_node("SFX")

#Variáveis exportáveis
export var maps = []

#Variáveis
var n_maps
var SFX_buttonpress = "res://Sounds/button_press.ogg"

#Sinais
signal menu_bgm

func _ready():
	n_maps = maps.size()
	
	connect("menu_bgm",main,"_on_Map_Select_menu_bgm")
	emit_signal("menu_bgm")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		main.change_scene(main.get_child(main.get_child_count() - 1),"res://Menus/Start Menu.tscn")

func _on_DebugMap_pressed():
	SFX_node.stream = load(SFX_buttonpress)
	SFX_node.play()
	main.change_scene(self,maps[0])


func _on_NewMapIHope_pressed():
	SFX_node.stream = load(SFX_buttonpress)
	SFX_node.play()
	main.change_scene(self,maps[1])
