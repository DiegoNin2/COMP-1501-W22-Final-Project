extends RigidBody2D


var speed = 350
var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var direction = (get_global_mouse_position() - global_position).normalized()
	linear_velocity = direction * speed
	damage = 1 + Game.cannon_level
	speed = 350 + (50 * Game.cannon_level)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	body.hit(damage)
	queue_free()
	
func hit(damage):
	pass
