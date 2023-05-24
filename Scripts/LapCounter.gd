extends Label

var lapCount
var totalNumberOfLaps

var lapTimeCounter

# Called when the node enters the scene tree for the first time.
func _ready():
	lapTimeCounter = get_node("../../Time/Label")
	lapCount = 0
	totalNumberOfLaps = 2
	self.text = str(lapCount) + "/" + str(totalNumberOfLaps)

func increaseLapCount():
	lapTimeCounter.resetLapStartTime(lapCount)
	if lapCount < totalNumberOfLaps:
		lapCount = lapCount + 1
		self.text = str(lapCount) + "/" + str(totalNumberOfLaps)
	else:
		print("Finished Race!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
