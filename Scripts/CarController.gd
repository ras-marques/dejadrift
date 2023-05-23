extends RigidBody2D

var accelerationValue = 120
var brakingValue = 60
var turningValue = 20

var acceleration = 0
var turning = 0
var handbrake = false

var turningAngle = 0

var powerVector
var turningVector

var driftMarks = preload("res://Scenes/drift_marks.tscn")
var driftSoundPlayer
var accelerateSoundPlayer

var drawBackDriftMarks = false
var drawFrontDriftMarks = false

var animatedSprite

var onGravel = false

var lapCounter

func _ready():
	animatedSprite = get_node("Sprite2D")
	driftSoundPlayer = get_node("ScreechSound")
	accelerateSoundPlayer = get_node("AccelerateSound")
	
	lapCounter = get_node("../Interface/CanvasLayer/LapCounter/Label")

func get_input():
	if Input.is_action_pressed("car_accelerate"):
		acceleration = accelerationValue
	elif Input.is_action_pressed("car_brake"):
		acceleration = -brakingValue
	else:
		acceleration = 0
	
	if Input.is_action_pressed("car_turn_left"):
		turningAngle = -PI/4
		turning = -turningValue
	elif Input.is_action_pressed("car_turn_right"):
		turningAngle = PI/4
		turning = turningValue
	else:
		turningAngle = 0
		turning = 0
	
	if Input.is_action_pressed("car_handbrake"):
		handbrake = true
	else:
		handbrake = false
#	if Time.get_ticks_msec() < 28000:
#		acceleration = 0

func _process(_delta):
	get_input()
	if(turning < 0): animatedSprite.set_frame(1)
	elif(turning > 0): animatedSprite.set_frame(2)
	else: animatedSprite.set_frame(0)
	
	if(drawBackDriftMarks):
		var newNode = driftMarks.instantiate()
		get_tree().get_root().add_child(newNode)
		newNode.z_index = -1
		newNode.position = self.position + Vector2(0,9).rotated(rotation)
		newNode.rotation = self.rotation
	if(drawFrontDriftMarks):
		var newNode = driftMarks.instantiate()
		get_tree().get_root().add_child(newNode)
		newNode.z_index = -1
		newNode.position = self.position - Vector2(0,9).rotated(rotation)
		newNode.rotation = self.rotation

func computeForceForTheWheel(velocity, badDirection):
	var velocityInBadDirection = velocity.dot(badDirection)
	var force = badDirection.normalized() * velocityInBadDirection * -1
	return force

func _physics_process(_delta):
	var backWheelPosition = Vector2(0, 9).rotated(rotation)     #this is good!
	var frontWheelPosition = Vector2(0, -9).rotated(rotation)   #this is good!
	
	var backWheelForwardForce = Vector2(sin(rotation), -cos(rotation)) * acceleration  #this is good!
	if(!handbrake):
		apply_force(backWheelForwardForce, backWheelPosition) #this is good!
	
	var backWheelAngle = rotation
	var frontWheelAngle = rotation + turningAngle
	
#	var frontWheelTurningForce = Vector2(sin(rotation + PI/2), -cos(rotation + PI/2)) * turning
	var backWheelVector = Vector2(sin(backWheelAngle), -cos(backWheelAngle))
	var frontWheelVector = Vector2(sin(frontWheelAngle), -cos(frontWheelAngle))
	
	var velocity = get_linear_velocity()
	var backNoSlipAngle = 0
	if backWheelVector.angle_to(velocity) > 0:
		backNoSlipAngle = backWheelAngle - PI/2
	else:
		backNoSlipAngle = backWheelAngle + PI/2
	var frontNoSlipAngle = 0
	if frontWheelVector.angle_to(velocity) > 0:
		frontNoSlipAngle = frontWheelAngle - PI/2
	else:
		frontNoSlipAngle = frontWheelAngle + PI/2
	
	var backNoSlipVector = Vector2(sin(backNoSlipAngle), -cos(backNoSlipAngle))
	var backWheelFrictionForce = computeForceForTheWheel(velocity, backNoSlipVector)
	if(!handbrake):
		apply_force(backWheelFrictionForce, backWheelPosition)
	else:
		apply_force(backWheelFrictionForce*0.7, backWheelPosition)
	
	var frontNoSlipVector = Vector2(sin(frontNoSlipAngle), -cos(frontNoSlipAngle))
	var frontWheelFrictionForce = computeForceForTheWheel(velocity, frontNoSlipVector)
	apply_force(frontWheelFrictionForce, frontWheelPosition)
	
#	print((int)(velocity.length()/2))
#	print(get_linear_velocity())
	
	if backWheelFrictionForce.length() > 55:
		drawBackDriftMarks = true
	else:
		drawBackDriftMarks = false
	if frontWheelFrictionForce.length() > 55:
		drawFrontDriftMarks = true
	else:
		drawFrontDriftMarks = false
	
	if backWheelForwardForce.length() != 0:
		if not accelerateSoundPlayer.playing or accelerateSoundPlayer.get_playback_position() > 3:
			accelerateSoundPlayer.play()
			accelerateSoundPlayer.seek(0.3)
	else:
		accelerateSoundPlayer.stop()
	
	if (backWheelFrictionForce.length() > 55 or frontWheelFrictionForce.length() > 55):
		if not driftSoundPlayer.playing or driftSoundPlayer.get_playback_position() > 1.4:
			driftSoundPlayer.play()
			driftSoundPlayer.seek(.4)
	elif backWheelFrictionForce.length() < 55 and frontWheelFrictionForce.length() < 55:
		driftSoundPlayer.stop()

	if onGravel:
		var gravelForce = Vector2(sin(rotation), -cos(rotation)) * -velocity.length()  #this is good!
		apply_force(gravelForce, backWheelPosition) #this is good!

func _on_area_2d_body_entered(body):
	if body.name == "Car":
		onGravel = true

func _on_gravel_pits_body_exited(body):
	if body.name == "Car":
		onGravel = false

var checkPoints = [0, 1, 2, 3]
var nextIndex = 0
func _on_track_check_points_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Car":
		if local_shape_index == checkPoints[nextIndex]:
			if nextIndex == 0:
				lapCounter.increaseLapCount()
			
			if nextIndex < checkPoints.size() - 1:
				nextIndex = nextIndex + 1
			else:
				nextIndex = 0
				
