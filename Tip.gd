extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var origin = ""
var valid = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if origin == "Upgrades":
		valid = true
	
	if valid:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
