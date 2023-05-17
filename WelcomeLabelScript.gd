extends Label

var start_time_msec

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time_msec = Time.get_ticks_msec()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var elapsed_time_sec = (Time.get_ticks_msec() - start_time_msec) / 1000.0
	if elapsed_time_sec < 5:
		self.text = "Welcome to my game!"
	elif elapsed_time_sec < 10:
		self.text = "Before you start drifting"
	elif elapsed_time_sec < 15:
		self.text = "I would like to let you know"
	elif elapsed_time_sec < 20:
		self.text = "you should use WASD."
	elif elapsed_time_sec < 24:
		self.text = "That's it, have fun!"
	elif elapsed_time_sec < 25:
		self.text = "3"
	elif elapsed_time_sec < 26:
		self.text = "2"
	elif elapsed_time_sec < 27:
		self.text = "1"
	elif elapsed_time_sec < 27.5:
		self.text = "GO!"
	elif elapsed_time_sec < 28:
		self.text = ""
	elif elapsed_time_sec < 28.5:
		self.text = "GO!"
	elif elapsed_time_sec < 29:
		self.text = ""
	elif elapsed_time_sec < 29.5:
		self.text = "GO!"
	elif elapsed_time_sec < 30:
		self.text = ""
	elif elapsed_time_sec < 30.5:
		self.text = "GO!"
	elif elapsed_time_sec < 31:
		self.text = ""
	elif elapsed_time_sec < 35:
		self.text = "GO!"
	else:
		self.text = ""
