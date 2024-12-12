# player.gd
"""
Using export keyword on first var speed lets us set its val in Inspector.

# PlayerArea2D
$ is shorthand for get_node(). 
$AnimatedSprite2D.play() = get_node("AnimatedSprite2D").play().
GDScr: $ returns node at relative path from curr node or null if node not found. 
Since AnimatedSprite2D is child of the curr node we can use $AnimatedSprite2D.

use clamp() to prevent it from leaving screen, restricting it to a given range.
delta in _process() param = frame length - time prev frame took to complete.
using delta val keeps movement constant even if frame rate changes.

"""
extends Area2D

signal hit
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
# Called every frame. Hides the player at the start.
# Updates player movement and animation based on input, restricts the player within screen bounds.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# detect if key pressed using boolean Input.is_action_pressed().
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# ADDITION 2.1: Prog2 - Interaction/Movement -----
	# Increase speed only while space bar is actively held down.
	# First do: Project -> Project Settings -> Input Map, add space as "speed_up"
	var current_speed = speed
	if Input.is_action_pressed("speed_up"):  # mapped action for space bar
		current_speed += 500
	# ------------------------------------------- 2.1

	# Apply velocity if there's movement.
	if velocity.length() > 0:
		# ADDITION 2.2: Prog2 - Interaction/Movement -----
		# velocity = velocity.normalized() * speed
		# Change above line to:
		velocity = velocity.normalized() * current_speed # so adjusted speed is actually used in movement calculations.
		# ------------------------------------------- 2.2
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# now after movement direction, can update player position
	# use clamp to prevent from leaving screen by restricting range
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# cahnge animation based on direction
	# flip exsitisting right and top
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# = $AnimatedSprite2D.flip_h boolean if vel.x/y < 0 
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# reset position of and show player when starting new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# emit signal when enemy hits player. 
# disable player collision so hit signal not triggered > 1 times.
func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
	










