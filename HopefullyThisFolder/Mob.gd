# Mob.gd
"""
# $StartPositionMarker2D
# $MobRigidBody2D
# CollisionObject2D under RigidBody2D inspector, expand Collision uncheck 1 inside Mask so mobs don't collide with each other.
"""

extends RigidBody2D
# ADDITION 2.3: Prog2 - Interaction/Movement -----
var base_speed = 300  # Set default speed 
var curr_speed = base_speed  #  Initialize mob's speed with base val
# -------------------------------------------- 2.3

# Called when the node enters the scene tree for the first time.
# randomly choose 1 of the 3 animation types.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ADDITION 2.4: Prog2 - Interaction/Movement -----
	#pass
	# Check if the spacebar (or another condition) is pressed and adjust mob speed
	if Input.is_action_pressed("speed_up"):  # Use same input mapping as player's "speed_up"
		curr_speed = base_speed - 220 
	else:
		curr_speed = base_speed  # Reset to base speed
		
	# Apply movement by setting linear velocity:
	# Note: Since mobs are only moving from right to left (horizontally), 
	# you only need to control the X-axis velocity.
	linear_velocity.x = -curr_speed  # Move left based on speed
	# -------------------------------------------- 2.4

# Deletes the mob when it leaves the screen to free memory.
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

