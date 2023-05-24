extends Label

var start_time_msec
var bestLap_time_msec = 0
var bestLapTimeLoaded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time_msec = Time.get_ticks_msec()

func newLapTime(lapTime):
	if lapTime < bestLap_time_msec or not bestLapTimeLoaded:
		bestLapTimeLoaded = true
		bestLap_time_msec = lapTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var lapTime_milliseconds = bestLap_time_msec % 1000
	var lapTime_seconds = bestLap_time_msec / 1000
	var lapTime_minutes = lapTime_seconds / 60
	lapTime_seconds = lapTime_seconds % 60
	self.text = "Best Lap %02d:%02d:%03d" % [lapTime_minutes, lapTime_seconds, lapTime_milliseconds]
