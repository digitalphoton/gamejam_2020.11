#Main.gc
extends Node

#Nodes
onready var BGM = get_node("BGM")

#Variáveis
var current_scene

#Variáveis exportáveis
#BGMs
export var BGMs = {"Menu":"res://Music/menu.ogg"}

func change_scene(scene,new_scene_path):
	call_deferred("_deferred_change_scene",scene,new_scene_path)

func _deferred_change_scene(scene,new_scene_path):
	if scene != null:
		scene.free()
	var l = load(new_scene_path)
	current_scene = l.instance()
	self.add_child(current_scene)

#BGMs
func _on_Start_Menu_menu_bgm():
	if BGM.stream != load(BGMs.Menu):
		BGM.stream = load(BGMs.Menu)
		BGM.play()

func _on_Map_Select_menu_bgm():
	if BGM.stream != load(BGMs.Menu):
		BGM.stream = load(BGMs.Menu)
		BGM.play()

func _on_DebugMap_map_bgm():
	if BGM.stream != load(BGMs.Level1):
		BGM.stream = load(BGMs.Level1)
		BGM.play()

func _on_NewMapIHope_map_bgm():
	if BGM.stream != load(BGMs.Level3):
		BGM.stream = load(BGMs.Level3)
		BGM.play()
