extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 500
var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var direction = rotation + rand_range(-PI/4, PI/4)
	rotation = direction
	var velocity = Vector2(self.position.y, 1000).normalized() * speed
	linear_velocity = velocity.rotated(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > 1000:
		queue_free()


func _on_Laser_Gun_body_entered(body):
	body.hit(damage)
	queue_free()
	
func hit(damage):
	pass
