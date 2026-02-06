extends Node

@export var mob_scene: PackedScene
var score
var record_easy = 0
var record_medium = 0
var record_hard = 0
var save_path = "user://highscore.save" # user://, cartella creata da godot

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_hit() -> void:
	game_over()
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	if global.current_difficulty == global.level.EASY:
		if score > record_easy:
			$HUD.update_highscore(record_easy)
			$HUD.show_message("New Record Easy!")
			salva_dati()
	elif global.current_difficulty == global.level.MEDIUM:
		if score > record_medium:
			$HUD.update_highscore(record_medium)
			$HUD.show_message("New Record Medium!")
			salva_dati()
	elif global.current_difficulty == global.level.HARD:
		if score > record_hard:
			$HUD.update_highscore(record_hard)
			$HUD.show_message("New Record Hard!")
			salva_dati()
	
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	carica_dati()
	get_tree().paused = false
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	if global.current_difficulty == global.level.EASY:
		$HUD.update_highscore(record_easy)
	elif global.current_difficulty == global.level.MEDIUM:
		$HUD.update_highscore(record_medium)
	elif global.current_difficulty == global.level.HARD:
		$HUD.update_highscore(record_hard)
	
	await get_tree().create_timer(2.0).timeout
	$HUD/Message.hide()


func _on_mob_timer_timeout():
	
	var mob = mob_scene.instantiate() # crea una nuova copia del mob
	
	mob.scegli_tipo_casuale()
	
	# sceglie una posizione random sul bordo
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# setta la posizione del mob su quella randomica
	mob.position = mob_spawn_location.position
	
	# lo fai ruotare di 90 gradi verso il centro
	var direction = mob_spawn_location.rotation + PI / 2
	
	# aggiunge randomicita alla direzione
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(mob.min_speed, mob.max_speed), 0.0)
	
	if global.current_difficulty == global.level.EASY:
		velocity *= 0.8  # Riduci velocità
	elif global.current_difficulty == global.level.HARD:
		velocity *= 1.6  # Aumenta velocità mostruosamente
		
		
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_hud_start_game() -> void:
	pass # Replace with function body.


func salva_dati():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var dati_da_salvare = {
		"easy": record_easy,
		"medium": record_medium,
		"hard": record_hard
	}
	file.store_var(dati_da_salvare)
	file.close()

func carica_dati():
	var filepath = "user://savegame.save"  # Usa una var per consistenza
	if FileAccess.file_exists(filepath):
		var file = FileAccess.open(filepath, FileAccess.READ)
		if file != null:  # Controllo apertura
			var dati_caricati = file.get_var()
			file.close()  # Correggi: aggiungi ()
			
			# NUOVO: Controlla se è un Dictionary valido
			if dati_caricati is Dictionary:
				record_easy = dati_caricati.get("easy", 0)    # .get() è sicuro, default 0 se manca
				record_medium = dati_caricati.get("medium", 0)
				record_hard = dati_caricati.get("hard", 0)
				print("Record caricati: Easy=", record_easy, " Medium=", record_medium, " Hard=", record_hard)
			else:
				print("ATTENZIONE: File corrotto (non è un dizionario)! Reset record.")
				record_easy = 0
				record_medium = 0
				record_hard = 0
		else:
			print("Errore apertura file, reset record.")
			record_easy = 0
			record_medium = 0
			record_hard = 0
	else:
		print("Nessun file salvataggio trovato, record=0")
		record_easy = 0
		record_medium = 0
		record_hard = 0
