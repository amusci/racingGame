extends CharacterBody2D

var wheel_base = 70
var steering_angle = 15
var vehicle_velocity = Vector2.ZERO  # Renamed to avoid conflict
var acceleration = Vector2.ZERO
var engine_power = 800
var steer_direction = 0



func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	calculate_steering(delta)
	vehicle_velocity += acceleration * delta

	move_and_slide()  # No need to pass vehicle_velocity, it will use internal velocity

func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_direction = turn * steering_angle
	
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
		

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	
	rear_wheel += vehicle_velocity * delta
	front_wheel += vehicle_velocity.rotated(deg_to_rad(steer_direction)) * delta

	var new_heading = (front_wheel - rear_wheel).normalized()
	vehicle_velocity = new_heading * vehicle_velocity.length()
	rotation = new_heading.angle()

	# Update the internal velocity
	velocity = vehicle_velocity  # Assign the calculated velocity to the internal velocity
