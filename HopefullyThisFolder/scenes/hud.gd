# hud.gd
extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# A boolean to track if the info screen is currently visible
var info_screen_visible = false

# Reference to the EndAnimation sprite in the HUD.
@onready var end_animation = $EndAnimation  # Make sure this is the correct path to the EndAnimation node.

# Called when the node enters the scene tree for the first time.
# Initializes the game, loads the start menu, and prepares the splash screen.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Generally used to update game logic, animations, player input.
func _process(delta):
	pass

# temporarily show text like "Get Ready"
func show_message(text):
	if info_screen_visible:  # Exit if info screen is on
		return
		
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
	# ADDITION: Prog1 - Splash screen -----
	# Adds text "Go!" for one second after "Get Ready!" splash screen. 
	#"""
	# Wait for the current message ("Get Ready") to finish (2 seconds).
	await $MessageTimer.timeout
	# After "Get Ready" is displayed for 2 seconds, show "Go!" for 1 second.
	$Message.text = "Go!"
	$Message.show()
	# Wait for 1 second before hiding "Go!".
	await get_tree().create_timer(1.0).timeout
	# Hide the message after showing "Go!".
	$Message.hide()
	#"""
	# ------------------------------------- 1

# process events after loss. 
# show game over 2 secs, go to title screen, pause, show start button.
func show_game_over():
	if info_screen_visible:  # Exit if info screen is on
		return
		
	# Show the end animation.
	show_end_animation()
	await get_tree().create_timer(2.0).timeout
	
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Ducks!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	
	$StartButton.show()
	$InfoButton.show()  # Ensure InfoButton is visible on game over
	
func show_end_animation():
	# Show the EndAnimation sprite and play its animation.
	end_animation.visible = true
	end_animation.play("End")  # Assuming "End" is the name of your animation in the AnimatedSprite node.
	
	# Optional: Delay before hiding it again.
	await get_tree().create_timer(3.2).timeout  # Adjust time as needed
	end_animation.visible = false

# Updates score display with current score.
func update_score(score):
	$ScoreLabel.text = str(score)
	
	# Updates high score display with the current high score.
func update_highscore(highscore):
	$HighScoreLabel.text = "Highscore: " + str(highscore)
	
# Connect StartButton pressed() signal and MessageTimer timeout() signal to HUD node, then:
# Called when the start button pressed. Hides button and emits signal to start game.
func _on_start_button_pressed():
	# Hide the InfoButton and InfoScreen when the game starts
	$InfoButton.hide()
	$InfoScreen.hide()
	info_screen_visible = false  # Reset the visibility tracker
	
	# Hide the StartButton and start the game
	$StartButton.hide()
	start_game.emit()

# Handles info button press to toggle the info screen
func _on_info_button_pressed():
	info_screen_visible = !info_screen_visible  # Toggle visibility state

	# Set visibility based on the state
	$InfoScreen.visible = info_screen_visible
	$StartButton.visible = !info_screen_visible
	$Message.visible = !info_screen_visible

# Hides the message when the message timer times out.
func _on_message_timer_timeout():
	if not info_screen_visible:  # Only show if info screen is off
		$Message.hide()


"""  Notes: --------
func show_game_over():
Can use `SceneTree.create_timer()` to add brief delays, like
waiting before showing the "Start" button, instead of a Timer node.
"""
