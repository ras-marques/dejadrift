extends Label

var car

# Called when the node enters the scene tree for the first time.
func _ready():
	car = get_tree().get_root().get_node("/root/Level1/Car")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = (int)(car.get_linear_velocity().length()/3)
	self.text = str(speed) + "KM/H"
