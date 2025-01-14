extends Area2D


var damage = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Firing.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Laserbeam_body_entered(body):
	body.hit(damage)
	damage = 0


func _on_Firing_finished():
	queue_free()
