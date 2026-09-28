extends CharacterBody2D

@export var speed = 200
@onready var animated_sprite = $AnimatedSprite2D
const JUMP_VELOCITY = -400.0

var last_direction = "down"
var is_action_playing = false

func play_action_animation(action_name):
	is_action_playing = true
	animated_sprite.play(action_name + "_" + last_direction)
	
func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		play_action_animation("attack")
	elif event.is_action_pressed("test_hit"):
		play_action_animation("hit")
	elif event.is_action_pressed("test_die"):
		play_action_animation("die")

func update_movement_animation(input_direction):
	if input_direction == Vector2.ZERO:
		animated_sprite.play("idle_" + last_direction)
	else:
		animated_sprite.play("run_" + last_direction)
		
func update_direction(input_direction):
	if input_direction.y < 0:
		last_direction = "up"
	elif input_direction.y > 0:
		last_direction = "down"
	elif input_direction.x < 0:
		last_direction = "left"
	elif input_direction.x > 0:
		last_direction = "right"
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Input.get_vector("move_left", "move_right", "move_up",
	"move_down")
	velocity = input_direction * speed
	update_direction(input_direction)
	if not is_action_playing:
		update_movement_animation(input_direction)
	move_and_slide()
	

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	is_action_playing = false
