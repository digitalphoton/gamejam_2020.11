#Start Menu.gd
extends Control

#Nodes
onready var main 		= get_parent()
onready var SFX_node	= main.get_node("SFX")

#Variáveis
var SFX_buttonpress = "res://Sounds/button_press.ogg"

#Sinais
signal menu_bgm

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_START_pressed():
	SFX_node.stream = load(SFX_buttonpress)
	SFX_node.play()
	main.change_scene(self,"res://Menus/Map_Select.tscn")

func _on_QUIT_pressed():
	SFX_node.stream = load(SFX_buttonpress)
	SFX_node.play()
	get_tree().quit()

func _on_Main_ready():
	connect("menu_bgm",main,"_on_Start_Menu_menu_bgm")
	emit_signal("menu_bgm")
