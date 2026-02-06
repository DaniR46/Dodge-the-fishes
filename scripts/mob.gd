extends RigidBody2D

var min_speed = 150.0
var max_speed = 250.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
	var speed_multiplier = 1.0
	
	if global.current_difficulty == global.level.EASY:
		speed_multiplier = 0.7 # 30% piu lenti
	if global.current_difficulty == global.level.MEDIUM:
		speed_multiplier = 1.0 # velocita invariata
	if global.current_difficulty == global.level.HARD:
		speed_multiplier = 1.6 # 60% piu veloci
		
func scegli_tipo_casuale():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	var random_type = mob_types.pick_random()
	$AnimatedSprite2D.play(random_type)
	match random_type:
		"tartug":
			scale = Vector2(1,1)
			$CollisionShapeTartug.disabled = false
			$CollisionShapeLight.disabled = true
			$CollisionShapeShark.disabled = true
		"shark":
			scale = Vector2(2, 2)
			min_speed = 250
			max_speed = 300
			
			$CollisionShapeTartug.disabled = true
			$CollisionShapeLight.disabled = true
			$CollisionShapeShark.disabled = false
		"light":
			scale = Vector2(0.80, 0.80)
			min_speed = 100
			max_speed = 200
			
			$CollisionShapeTartug.disabled = true
			$CollisionShapeLight.disabled = false
			$CollisionShapeShark.disabled = true
			

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # elimina il nodo alla fine del frame
