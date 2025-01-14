extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Tutorial Button".pressed = Game.tutorials
	$"Music Slider".value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$"SFX Slider".value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))


func _on_Tutorial_Button_toggled(button_pressed):
	Game.tutorials = button_pressed


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_HSlider2_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_BackButton_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
