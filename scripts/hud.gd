extends CanvasLayer

signal start_game # notifica il main che il tasto start è stato premuto

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	
	# aspetta finche finisce il tempo
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Fishes!"
	$Message.show()
	
	# fa un one-shot timer e aspetta che finisca
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()
	
func on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed() -> void:
	pass # Replace with function body.
	
func update_highscore(new_highscore):
	$HighScoreLabel.text = "Best: " + str(new_highscore)
