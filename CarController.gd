extends RigidBody2D

var accelerationValue = 1
var brakingValue = 0.5
var acceleration = 0

var frontWheelAngle = 0

var vectorDebug

func _ready():
	vectorDebug = get_node("Arrow")

func get_input():	
	if Input.is_action_pressed("car_accelerate"):
		acceleration = accelerationValue
	elif Input.is_action_pressed("car_brake"):
		acceleration = -brakingValue
	else:
		acceleration = 0
	
	if Input.is_action_pressed("car_turn_left"):
		frontWheelAngle = -45*PI/180
	elif Input.is_action_pressed("car_turn_right"):
		frontWheelAngle = 45*PI/180
	else:
		frontWheelAngle = 0

func _process(_delta):
	get_input()

func computeForceForTheWheel(velocity, badDirection):
	var velocityInBadDirection = velocity.dot(badDirection)
	print(velocityInBadDirection)
	var badDirectionAngle = atan2(badDirection.y, badDirection.x)
	var force = Vector2(sin(badDirectionAngle), cos(badDirectionAngle)) * -0.9 * velocityInBadDirection
	return force

func _physics_process(_delta):
	var backRightTirePosition = Vector2(8, 9)
	var backLeftTirePosition = Vector2(-8, 9)
	var frontRightTirePosition = Vector2(8, -9)
	var frontLeftTirePosition = Vector2(-8, -9)

	var angle = rotation
	var velocity = get_linear_velocity()
	
	var backLeftTireForwardForce = Vector2(sin(angle), cos(angle)) * acceleration  #origin is on the top left, so up is down, accel is inverted so it matches convention
	var backRightTireForwardForce = Vector2(sin(angle), cos(angle)) * acceleration #origin is on the top left, so up is down, accel is inverted so it matches convention

	var frontLeftTireBadDirectionAngle = 0
	var frontRightTireBadDirectionAngle = 0
	if frontWheelAngle > 0:
		frontLeftTireBadDirectionAngle = frontWheelAngle - PI/2
		frontRightTireBadDirectionAngle = frontWheelAngle - PI/2
	elif frontWheelAngle < 0:
		frontLeftTireBadDirectionAngle = frontWheelAngle + PI/2
		frontRightTireBadDirectionAngle = frontWheelAngle + PI/2
	
	var frontLeftTireBadDirectionVector = Vector2(sin(frontLeftTireBadDirectionAngle), cos(frontLeftTireBadDirectionAngle))
	var frontRightTireBadDirectionVector = Vector2(sin(frontRightTireBadDirectionAngle), cos(frontRightTireBadDirectionAngle))
	
	var backLeftTireBadDirectionAngle = -PI/2
	var backRightTireBadDirectionAngle = PI/2
	
	var backLeftTireBadDirectionVector = Vector2(sin(backLeftTireBadDirectionAngle), cos(backLeftTireBadDirectionAngle))
	var backRightTireBadDirectionVector = Vector2(sin(backRightTireBadDirectionAngle), cos(backRightTireBadDirectionAngle))
	
#	arrow.rotation = frontWheelAngle
#	vectorDebug.rotation = frontWheelVectorAngle
#	vectorDebug.rotation = frontRightTireForceAngle
#	vectorDebug.rotation = backLeftTireBadDirectionAngle
#	vectorDebug.rotation = frontLeftTireBadDirectionAngle
#	vectorDebug.rotation = debugAngle
#	vectorDebug.rotation = frontWheelForceAngle
	
#	var backLeftTireFrictionForce = computeForceForTheWheel(velocity, backLeftTireBadDirectionVector)
#	var backRightTireFrictionForce = computeForceForTheWheel(velocity, backRightTireBadDirectionVector)
#	var frontLeftTireFrictionForce = computeForceForTheWheel(velocity, frontLeftTireBadDirectionVector)
#	var frontRightTireFrictionForce = computeForceForTheWheel(velocity, frontRightTireBadDirectionVector)
	
	var velocityInBadDirection = velocity.dot(frontLeftTireBadDirectionVector)
	print(velocityInBadDirection)
	var badDirectionAngle = atan2(frontLeftTireBadDirectionVector.y, frontLeftTireBadDirectionVector.x)
	var force = Vector2(sin(badDirectionAngle), cos(badDirectionAngle)) * -0.9 * velocityInBadDirection
	print(force)
	
	apply_impulse(backRightTireForwardForce, backRightTirePosition)
	apply_impulse(backLeftTireForwardForce, backLeftTirePosition)
	
#	apply_impulse(backRightTirePosition, backRightTireFrictionForce)
#	apply_impulse(backLeftTirePosition, backLeftTireFrictionForce)
#	apply_impulse(frontRightTirePosition, frontRightTireFrictionForce)
#	apply_impulse(frontLeftTirePosition, frontLeftTireFrictionForce)
