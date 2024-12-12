# main.gd
# $StartPositionMarker2D
# MobPath2D
# MobSpawnLocationPathFollow2D
# Other Node CanvasLayer named HUD = "heads-up display"
# AudioStreamPlayer
extends Node

@export var mob_scene: PackedScene
var score
var highscore = 0 # ------------------------------------- 4

# Called when the node enters the scene tree for the first time.
# Initializes the main game setup. Not called automatically; it's for ltr initialization.
func _ready():
	# new_game() # game will start automatically. for testing purposes. 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

""" # Notes:
MobTimer: Controls mob spawn frequency
ScoreTimer: Increments score every second
StartTimer: Delays game start
StartPosition: Player’s start position marker
"""
# Ends the game, stops all timers, and shows the game over screen. update highscore.
func game_over():
	# ------------------------------------- 4
	# Update highscore if the current score is higher
	if score > highscore:
		highscore = score
	# Update HUD to show highscore
	$HUD.update_highscore(highscore)
	# ------------------------------------- 4
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	# death sound effect:
	$Music.stop()
	$DeathSound.play()

# Starts a new game by resetting score, player, and timers, and deletes all existing mobs.
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	# update score display and show rdy mssg
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	# after all "mob"s in mobs group: call_group() func function calls named func on every node in a group, here we tell every mob to delete itself.
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

# DONE: Connect Timer nodes' timeout() signal to main script. 
# Increments the player's score by 1 every second and updates the score display.
func _on_score_timer_timeout():
	score += 1
	# keep display synced with changing score:
	$HUD.update_score(score)

# Starts the mob and score timers when the game is ready to begin.
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
"""	# Notes:
# `_on_mob_timer_timeout() create a mob set position and direction using `PathFollow2D`,
# and assign random speed (150.0-250.0). Add new instance to scene with `add_child()`.
# Godot uses radians for angles; Pi (~3.1415) = half turn. TAU = 2 PI. deg_to_rad() and rad_to_deg() convert.
"""
# Spawns a mob at a random location on the path, sets its direction and speed, and adds it to the scene.
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
