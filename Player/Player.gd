extends CharacterBody2D

@export var acceleration : float = 400
@export var max_speed : float = 80
@export var roll_speed : float = 120
@export var friction : float = 1000
@export var starting_position : Vector2 = Vector2(0,0)

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_direction : Vector2 = Vector2.LEFT
var stats = PlayerStats

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sword_hitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox

func _ready():
	stats.no_health.connect(queue_free)
	animation_tree.active = true
	update_animation_parameters(starting_position)
	sword_hitbox.knockback_direction = roll_direction

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_State(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	# Get input direction
	# When pressing a key we set the input vector that describes the desired movement
	var input_direction : Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	input_direction = input_direction.normalized()
	
	# Update velocity
	if input_direction != Vector2.ZERO:
		roll_direction = input_direction
		sword_hitbox.knockback_direction = roll_direction
		update_animation_parameters(input_direction)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta)
	else:
		#If the keys are not pressed the player will tend to stop with a friction 
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	# Attack State Transition
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

	# Roll State Transition
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	# Move and slide
	move_and_slide()

func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func attack_animation_finished():
	state = MOVE

func roll_State(delta):
	velocity = roll_direction * roll_speed
	animation_state.travel("Roll")
	move_and_slide()

func roll_animation_finished():
	state = MOVE

func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Run/blend_position", move_input)
		animation_tree.set("parameters/Attack/blend_position", move_input)
		animation_tree.set("parameters/Roll/blend_position", move_input)

func _on_hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
