#Pit.gd
#The most complicated of scripts, surpasses the complexity of a neural network
extends Node2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.kill()
