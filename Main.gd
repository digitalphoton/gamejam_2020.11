#Main.gc
extends Node

#Variáveis
var current_scene

func change_scene(scene,new_scene_path):
	call_deferred("_deferred_change_scene",scene,new_scene_path)

func _deferred_change_scene(scene,new_scene_path):
	if scene != null:
		scene.free()
	var l = load(new_scene_path)
	current_scene = l.instance()
	self.add_child(current_scene)
