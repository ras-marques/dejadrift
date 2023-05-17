extends RigidBody2D

var accelerationValue = 120
var brakingValue = 40
var turningValue = 20

var acceleration = 0
var turning = 0

var turningAngle = 0

var powerVector
var turningVector

var packedScene = preload("res://Scenes/drift_marks.tscn")

var drawDriftMarks = false

func _ready():
	pass

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
		
#	if Time.get_ticks_msec() < 28000:
#		acceleration = 0

func _process(_delta):
	get_input()
	if(drawDriftMarks):
		var newNode = packedScene.instantiate()
		get_tree().get_root().add_child(newNode)
		newNode.z_index = -1
		newNode.position = self.position
		newNode.rotation = self.rotation

func computeForceForTheWheel(velocity, badDirection):
	var velocityInBadDirection = velocity.dot(badDirection)
	var force = badDirection.normalized() * velocityInBadDirection * -0.7
	return force

func _physics_process(_delta):
	var backWheelPosition = Vector2(0, 9).rotated(rotation)     #this is good!
	var frontWheelPosition = Vector2(0, -9).rotated(rotation)   #this is good!
	
	var backWheelForwardForce = Vector2(sin(rotation), -cos(rotation)) * acceleration  #this is good!
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
	apply_force(backWheelFrictionForce, backWheelPosition)
	
	var frontNoSlipVector = Vector2(sin(frontNoSlipAngle), -cos(frontNoSlipAngle))
	var frontWheelFrictionForce = computeForceForTheWheel(velocity, frontNoSlipVector)
	apply_force(frontWheelFrictionForce, frontWheelPosition)
	
	if backWheelFrictionForce.length() > 55 or frontWheelFrictionForce.length() > 55:
		drawDriftMarks = true
	else:
		drawDriftMarks = false
