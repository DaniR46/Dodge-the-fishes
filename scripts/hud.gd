extends CanvasLayer

signal start_game # notifica il main che il tasto start è stato premuto

var icona_pausa = preload("res://assets/HUD/gui/gui_buttons_vol1/sprites/buttons/g23174.png")
var icona_riprendi = preload("res://assets/HUD/gui/gui_buttons_vol1/sprites/buttons/g21526.png")

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	$PauseButton.texture_normal = icona_pausa
	
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
	$DifficultyMenu.show()
	
func on_message_timer_timeout():
	$Message.hide()

	
func update_highscore(new_highscore):
	$HighScoreLabel.text = "Best: " + str(new_highscore)


func _on_pause_button_pressed():
	# Se il gioco NON in pausa, lo mettiamo in pausa
	if $PauseButton.button_pressed == true:
		get_tree().paused = true
	else:
		get_tree().paused = false
	


func _on_easy_button_pressed() -> void:
	scegli_difficolta(0) # 0 = Facile
	start_game.emit()

func _on_medium_button_pressed() -> void:
	scegli_difficolta(1) # 1 = Normale
	start_game.emit()

func _on_hard_button_pressed() -> void:
	scegli_difficolta(2) # 2 = Difficile
	start_game.emit()
	
func scegli_difficolta(livello):
	get_tree().paused = false
	global.current_difficulty = livello
	start_game.emit()
	$DifficultyMenu.hide()
