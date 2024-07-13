extends CharacterBody3D

# Constants for facing directions
const FACING_DOWN = 0
const FACING_RIGHT = 1
const FACING_UP = 2
const FACING_LEFT = 3

# Number of frames per animation
const FRAMES_PER_ANIMATION = 4

# Current facing direction and frame
var facing = FACING_DOWN
var frame = 0

# Animation timer
var animation_timer = 0.0
var animation_speed = 0.3 # Adjust this value to change the speed of the animation

# Movement speed
var speed = 5.0

func _ready():
	# Set initial frame
	update_frame()

func _process(delta):
	var direction = Vector3.ZERO

	# Update facing direction and direction vector based on input
	if Input.is_action_pressed("ui_down"):
		facing = FACING_DOWN
		direction.z += 1
	elif Input.is_action_pressed("ui_right"):
		facing = FACING_RIGHT
		direction.x += 1
	elif Input.is_action_pressed("ui_up"):
		facing = FACING_UP
		direction.z -= 1
	elif Input.is_action_pressed("ui_left"):
		facing = FACING_LEFT
		direction.x -= 1

	# Normalize direction to prevent faster diagonal movement
	if direction != Vector3.ZERO:
		direction = direction.normalized() * speed
		# Cycle through frames if moving
		animation_timer += delta
		if animation_timer >= animation_speed:
			animation_timer = 0.0
			frame = (frame + 1) % FRAMES_PER_ANIMATION
	else:
		# Reset to the first frame if not moving
		frame = 0

	# Apply movement
	velocity = direction
	# Update position using the internal movement function of CharacterBody3D
	move_and_collide(velocity * delta)

	# Update the displayed frame
	update_frame()

func update_frame():
	# Calculate the frame index and update the sprite
	var frame_index = facing * FRAMES_PER_ANIMATION + frame
	$Sprite3D.frame = frame_index
