extends Label

var lap_start_time_msec
var bestLapLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	lap_start_time_msec = 0
	bestLapLabel = get_node("../../BestLap/Label")

func resetLapStartTime(lapCount):
	if lapCount != 0:
		var lapTime = Time.get_ticks_msec() - lap_start_time_msec
		bestLapLabel.newLapTime(lapTime)
		
	lap_start_time_msec = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var trackTime_milliseconds
	if lap_start_time_msec == 0:
		trackTime_milliseconds = 0
	else:
		trackTime_milliseconds = Time.get_ticks_msec() - lap_start_time_msec
		
	var trackTime_seconds = trackTime_milliseconds / 1000
	var trackTime_minutes = trackTime_seconds / 60
	trackTime_milliseconds = trackTime_milliseconds % 1000
	trackTime_seconds = trackTime_seconds % 60
	self.text = "%02d:%02d:%03d" % [trackTime_minutes, trackTime_seconds, trackTime_milliseconds]
