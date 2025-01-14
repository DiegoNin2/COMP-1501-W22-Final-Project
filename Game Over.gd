extends Control





# Called when the node enters the scene tree for the first time.
func _ready():
	$Score.text = "SCORE: " + String(Game.score)
	if Game.score > Game.highscore:
		Game.highscore = Game.score
		$Highscore.text = "NEW HIGHSCORE!"
	else:
		$Highscore.text = "HIGHSCORE: " + String(Game.highscore)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RestartButton_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://StartMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
