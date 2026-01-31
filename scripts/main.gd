extends Node

@export var mob_scene: PackedScene
var score
var high_score = 0
var save_path = "user://highscore.save" # user://, cartella creata da godot

func _ready():
	load_highscore()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_hit() -> void:
	game_over()
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	if score > high_score:
		high_score = score
		save_highscore()
		$HUD.update_highscore(high_score)
	
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()
	
	$HUD.update_score(score)
	$HUD.update_highscore(high_score)
	$HUD.show_message("Get Ready")
	
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

func save_highscore():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(high_score)

func load_highscore():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		high_score = file.get_var()
	else : 
		high_score = 0
