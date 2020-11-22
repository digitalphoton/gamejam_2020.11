extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var y = 0
export var y_dif = 512
export var vel = 8
var doorOn = false
var rotx
var roty

func _process(_delta):
	
	rotx = cos(-self.transform.get_rotation() - PI/2)
	roty = sin(-self.transform.get_rotation() - PI/2)
	print(str(rotx) + "   " + str(roty))

func _on_Middle_button_Trigger(buttonOn):
	
	doorOn = buttonOn

func _physics_process(_delta):
	
	if doorOn and y < y_dif:
		self.position += Vector2(-rotx, roty)
		y += 1
	if not doorOn and y > 0:
		self.position += Vector2(rotx, -roty)
		y += -1
	
	
