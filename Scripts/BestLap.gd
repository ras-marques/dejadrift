extends Label

var start_time_msec

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time_msec = Time.get_ticks_msec()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	var trackTime_milliseconds = Time.get_ticks_msec() - start_time_msec
#	var trackTime_seconds = trackTime_milliseconds / 1000
#	var trackTime_minutes = trackTime_seconds / 60
#	trackTime_milliseconds = trackTime_milliseconds % 1000
#	trackTime_seconds = trackTime_seconds % 60
#	self.text = str(trackTime_minutes) + ":" + str(trackTime_seconds) + ":" + str(trackTime_milliseconds)
