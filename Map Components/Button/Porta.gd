extends RigidBody2D

#Variáveis exportadas
export var y_dif = 512
export var vel = 4

#Variáveis
var y = 0
var doorOn = false

func _ready():
	pass

func _physics_process(_delta):
	if doorOn and y < y_dif:
		self.position += Vector2(0, -vel)
		y += vel
	if not doorOn and y > 0:
		self.position += Vector2(0, vel)
		y += -vel


func _on_Button_button_Trigger(buttonOn):
	doorOn = buttonOn
	pass # Replace with function body.
