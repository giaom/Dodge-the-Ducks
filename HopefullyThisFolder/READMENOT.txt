------------------------------- READMENOT.txt: -------------------------------
This text file contains changes unused, irrelevant to, or not useful to
the class assignments, but personal notes or things I may want to go back to.
------------------------------------------------------------------------------


##############################################################################
Notes:
-----------------------------------------------------------------------------
Try using global variable that changes rather than mob currently scoping if spacebar is pressed.

If you have warnings about unused parameters (delta and body) and don't need them, 
you can prefix them with an underscore to indicate that they are intentionally unused.
Ex: func _process(_delta):  # Prefixing delta with an underscore

To map movement keys: Project -> Project Settings -> Input Map, add space as "speed_up"

Since mobs are only moving from right to left (horizontally), you only need to control the X-axis velocity.

##############################################################################
info button if statements and helpers
-----------------------------------------------------------------------------
# Handles info button press to toggle the info screen
func _on_info_button_pressed():
	
	# using helper methods because of long text
	if info_screen_visible:
		hide_info_screen()
	else:
		show_info_screen()
		
# Shows the info screen with game instructions
func show_info_screen():
	''' 
	$InfoScreen.text = "Press Info to return to homescreen. \n 
		\n How to Play:
		\n- Move your character with arrow keys
		\n- Avoid incoming mobs
		\n- Earn points by staying alive
		\n- Press 'Start' to begin!
		\n \n Boosts:
		\n- HOLD down SPACE to slow Mobs!
		\n- Careful! It will also speed you up!
		\n \n [Press Info to Return Home]" 
	'''
	$InfoScreen.show()
	info_screen_visible = true
	$StartButton.hide()  # Optionally hide the start button while info screen is open

# Hides the info screen and restores start and info buttons
func hide_info_screen():
	$InfoScreen.hide()
	info_screen_visible = false
	$StartButton.show()  # Restore start button when info screen is closed


-----------------------------------------------------------------------------
Trying to change mob speed by sending signal from player to mob scripts.
Does not crash, however mob speed does not change.
Easier to just detect keyboard input from mob script directly. 
Note: try using global variables? 
-----------------------------------------------------------------------------
# Mob.gd: 
	"""
# $StartPositionMarker2D
# $MobRigidBody2D
# CollisionObject2D under RigidBody2D inspector, expand Collision uncheck 1 inside Mask so mobs don't collide with each other.
"""

extends RigidBody2D
# ADDITION2.3: Prog2 - Interaction/Movement -----
var default_speed = 200  # Setting a default speed for the mob
var speed = default_speed  # Start game with the default speed
# -------------------------------------------- 2.3

# Called when the node enters the scene tree for the first time.
# randomly choose 1 of the 3 animation types.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
	# ADDITION2.4: Prog2 - Interaction/Movement -----
	# Connect to the player's speed change signal
	var player = get_node("/root/Main/Player")  # Absolute path to Player
	player.connect("speed_change", Callable(self, "_on_player_speed_change")) # Connect signal
	# ------------------------------------------- 2.4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ADDITION2.5: Prog2 - Interaction/Movement -----
	# pass
	# Change above line to below : movex mob using its curr speed
	position.x -= speed * delta  # Move left, can adjust 
	
# Function to respond to player's speed change signal
func _on_player_speed_change(speed_change_value):
	if speed_change_value == 0:
		speed = default_speed  # Reset speed to default
		print("2 Resetting speed to default:", speed) # DEBUG
	else:
		# speed = default_speed + speed_change_value  # Adjust mob speed based on the signal
		speed = clamp(default_speed + speed_change_value, 0, 500)  # no negative speed. Or do 0, default_speed
		print("3 Adjusted speed:", speed) # DEBUG
	# ------------------------------------------------ 2.5

# Deletes the mob when it leaves the screen to free memory.
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

# Player.gd:
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
signal speed_change  # ADDITION 2.6: declares the signal ----2.6
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

	# ADDITION2.1: Prog2 - Interaction/Movement -----
	# Increase speed only while space bar is actively held down.
	# First do: Project -> Project Settings -> Input Map, add space as "speed_up"
	var current_speed = speed
	if Input.is_action_pressed("speed_up"):  # mapped action for space bar
		current_speed += 500
		emit_signal("speed_change", -150)  # Lower mob speed
		print("Emitting speed_change with value: -500") # DEBUG
	else:  # spacebar not pressed, reset mob speed to default
		emit_signal("speed_change", 0) 
	# ------------------------------------------- 2.1

	# Apply velocity if there's movement.
	if velocity.length() > 0:
		# ADDITION2.2: Prog2 - Interaction/Movement -----
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
	
##############################################################################










