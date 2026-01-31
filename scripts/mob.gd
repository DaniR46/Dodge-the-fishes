extends RigidBody2D

var min_speed = 150.0
var max_speed = 250.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func scegli_tipo_casuale():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	var random_type = mob_types.pick_random()
	$AnimatedSprite2D.play(random_type)
	match random_type:
		"tartug":
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
