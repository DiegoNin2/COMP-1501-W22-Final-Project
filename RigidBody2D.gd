extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 350
export var damage = 0
var direction = rotation
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = rotation
	rotation = direction
	var velocity = Vector2(self.position.y, 1000).normalized() * speed
	linear_velocity = velocity.rotated(direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > 1000:
		queue_free()


func _on_Flamethrower_body_entered(body):
	body.hit(damage)
	queue_free()

func hit(damage):
	pass
