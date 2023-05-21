extends Label

var lapCount
var totalNumberOfLaps

# Called when the node enters the scene tree for the first time.
func _ready():
	lapCount = 1
	totalNumberOfLaps = 2
	self.text = str(lapCount) + "/" + str(totalNumberOfLaps)

func increaseLapCount():
	if lapCount < totalNumberOfLaps:
		lapCount = lapCount + 1
		self.text = str(lapCount) + "/" + str(totalNumberOfLaps)
	else:
		print("Finished Race!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
