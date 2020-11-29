#Start Menu.gd
extends Control

#Nodes
onready var main 		= get_parent()
onready var BGM_node	= main.get_node("BGM")
onready var SFX_node	= main.get_node("SFX")

#Variáveis exportaveis
export(String,FILE,"*.ogg") var bgm

#Variáveis
var sfx_buttonpress = "res://Sounds/button_press.wav"

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_START_pressed():
	SFX_node.stream = load(sfx_buttonpress)
	SFX_node.play()
	main.change_scene(self,"res://Menus/MapSelect.tscn")

func _on_QUIT_pressed():
	SFX_node.stream = load(sfx_buttonpress)
	SFX_node.play()
	get_tree().quit()

func _on_Main_ready():
	#Toca a BGM
	if BGM_node.stream != load(bgm):
		BGM_node.stream = load(bgm)
		BGM_node.play()
