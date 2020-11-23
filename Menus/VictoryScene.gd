#VictoryScene.gd
extends Control

#Nodes
onready var timer		= get_node("Timer")
onready var main		= get_parent()
onready var BGM_node	= main.get_node("BGM")
onready var SFX_node	= main.get_node("SFX")

#Variáveis exportadas
export(String,FILE,"*.ogg") var bgm

#Variáveis
var bgm_delay
var victory_sound 	= "res://Sounds/complete.ogg"

func _ready():
	SFX_node.stream = load(victory_sound)
	SFX_node.play()
	bgm_delay = SFX_node.stream.get_length()
	timer.set_wait_time(bgm_delay)
	timer.start()
	BGM_node.stop()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		main.change_scene(self,"res://Menus/StartMenu.tscn")

func _on_Timer_timeout():
	BGM_node.stream = load(bgm)
	BGM_node.play()
