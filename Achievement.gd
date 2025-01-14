extends Node2D


export var achievement_number = 0
var popup_mode = false
var achieved = false
var speed = 500


# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.text = Game.achievements[achievement_number][0]
	if popup_mode:
		$Body.text = "COMPLETED!"
	else:
		$Body.text = Game.achievements[achievement_number][1]
	achieved = Game.achievements[achievement_number][2]
	if achieved:
		$Trophy.visible = true
		$"Gold Border".visible = true
	else:
		$Trophy.visible = false
		$"Gold Border".visible = false



func _process(delta):
	if popup_mode:
		var velocity = Vector2.ZERO
		if position.x < 0 or speed < 0:
			velocity.x = speed
			position += velocity * delta
			if position.x >= 0:
				$Timer.start()
	
	if position.x < -400:
		queue_free()


func _on_Timer_timeout():
	speed *= -1
