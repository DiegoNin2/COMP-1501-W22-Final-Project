extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 350
var damage = 0
var explosion = load("res://Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_rotation(rand_range(-PI/4, PI/4)) 
	var direction = 0
	var velocity = Vector2.ZERO
	velocity.y = speed
	linear_velocity = velocity.rotated(direction)
	$AnimatedSprite.play("default")
	

func _process(delta):
	if position.y >= 850:
		var instance = explosion.instance()
		instance.position = position
		instance.damage = damage
		get_parent().add_child(instance)
		queue_free()



func _on_Bomb_body_entered(body):
	var instance = explosion.instance()
	instance.position = position
	instance.damage = damage
	get_parent().add_child(instance)
	queue_free()
	
func hit(damage):
	pass
