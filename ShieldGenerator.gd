extends StaticBody2D

var hit = false

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	# Show Tutorials
	if Game.tutorials and not Game.shield_tutorial:
		$Tips.visible = true
		Game.shield_tutorial = true
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	position.x = rng.randi_range(36, 714)
	position.y = rng.randi_range(100, 400)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit(damage):
	$Tips.visible = false
	if hit == false:
		emit_signal("destroyed")
		$Shutdown.play()
		hit = true


func _on_Shutdown_finished():
	queue_free()
