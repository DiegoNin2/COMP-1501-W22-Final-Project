extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()

func _on_StoryButton_pressed():
	get_tree().change_scene("res://Story.tscn")

func _on_SettingsButton_pressed():
	get_tree().change_scene("res://Controls.tscn")


func _on_HelpButton_pressed():
	get_tree().change_scene("res://HelpScreen.tscn")


func _on_AchievementButton_pressed():
	get_tree().change_scene("res://Achievements Menu.tscn")
