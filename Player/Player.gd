extends CharacterBody2D

@export var acceleration : float = 400
@export var max_speed : float = 80
@export var friction : float = 500
@export var starting_position : Vector2 = Vector2(0,0)

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_position)

func _physics_process(delta):
	# Get input direction
	# When pressing a key we set the input vector that describes the desired movement
	var input_direction : Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	input_direction = input_direction.normalized()
	
	# Update velocity
	if input_direction != Vector2.ZERO:
		update_animation_parameters(input_direction)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta)
	else:
		#If the keys are not pressed the player will tend to stop with a friction 
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# Move and slide
	print(velocity)
	move_and_slide()

func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Run/blend_position", move_input)
