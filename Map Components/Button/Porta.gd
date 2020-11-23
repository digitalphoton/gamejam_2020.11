extends RigidBody2D

#Variáveis exportadas
export var y_dif = 1024
export var vel = 8

#Variáveis
var y = 0
var doorOn = false
var rotx
var roty

func _ready():
	pass
func _process(_delta):
	
	rotx = cos(-self.transform.get_rotation() - PI/2)
	roty = sin(-self.transform.get_rotation() - PI/2)

func _on_Middle_button_Trigger(buttonOn):
	
	doorOn = buttonOn

func _physics_process(_delta):
	
	if doorOn and y < y_dif:
		self.position += Vector2(-rotx, roty)*vel
		y += vel
	if not doorOn and y > 0:
		self.position += Vector2(rotx, -roty)*vel
		y += -vel

func _on_Button_button_Trigger(buttonOn):
	doorOn = buttonOn

func _on_Key_unlock():
	doorOn = true
