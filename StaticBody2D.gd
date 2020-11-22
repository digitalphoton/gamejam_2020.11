extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var y = 0
export var y_dif = 512
export var vel = 4
var doorOn = false


func _on_Middle_button_Trigger(buttonOn):
	
	doorOn = buttonOn

func _physics_process(_delta):
	if doorOn and y < y_dif:
		self.position += Vector2(0, -vel)
		y += vel
	if not doorOn and y > 0:
		self.position += Vector2(0, vel)
		y += -vel
