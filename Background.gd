extends Node2D

var space
const BACKGROUND_SPEED = 150
const PAST_Y = 1500

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	space = [$Space1, $Space2, $Space3, $Space4, $Space5]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity
	for sprite in space:
		
		
		
