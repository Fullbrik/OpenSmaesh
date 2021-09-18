# NOTE: You don't have to use this class for your character, but it implements a lot of things for you.
# Things such as networked movement, input mapping, health, respawning, and more!

class_name Character extends CharacterBody3D

# Ground movement
@export var speed : float = 10.0
@export var acceleration : float = 60.0

# Air movement
@export var jump_velocity : float = 7
@export var gravity : float = -19
@export var air_acceleration : float = 10



var is_moving: bool = false
var y_velocity: float = 0

func _ready() -> void:
	pass

func _physics_process(delta):
	check_input(delta)
	apply_gravity(delta)
	move_and_slide()

func check_input(delta: float):
	var movement = Vector3()
	is_moving = false;
	
	# Direction movement
	if Input.is_action_pressed("move_right"):
		is_moving = true
		movement += global_transform.basis.x
	if Input.is_action_pressed("move_left"):
		is_moving = true
		movement -= global_transform.basis.x
	if Input.is_action_pressed("move_forward"):
		is_moving = true
		movement += -global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		is_moving = true
		movement -= -global_transform.basis.z
	
	# Jumping
	if Input.is_action_just_pressed("jump"):
		if(is_on_floor()): #We can only jump if we are on the floor
			y_velocity = jump_velocity
	
	set_velocity_from_movement(movement, delta)

func set_velocity_from_movement(movement: Vector3, delta: float):
	# Accelarate towords speed, but in the direction we are moving in
	linear_velocity = linear_velocity.move_toward(speed * movement, get_accelaration() * delta);

func apply_gravity(delta: float):	
	if(y_velocity < gravity):  # Make sure we don't go below gravity
		y_velocity = gravity
	else:
		y_velocity += gravity * delta # Start adding gravity
		
	linear_velocity.y = y_velocity

func get_accelaration():
	return acceleration
