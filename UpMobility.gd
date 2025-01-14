extends Button

onready var tip = preload("res://Tip.tscn")

func _on_UpMobility_mouse_entered():
	var tip_instance = tip.instance()
	tip_instance.origin = "Upgrades"
	
	tip_instance.rect_position = get_global_transform_with_canvas().origin - Vector2(50,30)
	tip_instance.get_node("HBoxContainer/VBoxContainer/Label").text = "Increases ship speed"
	
	add_child(tip_instance)
	yield(get_tree().create_timer(0.2), "timeout")
	if has_node("Tip") and get_node("Tip").valid:
		get_node("Tip").show()


func _on_UpMobility_mouse_exited():
	get_node("Tip").free()


func _unhandled_input(event):
	if event.is_action_pressed("pause") and has_node("Tip"):
		get_node("Tip").free()
