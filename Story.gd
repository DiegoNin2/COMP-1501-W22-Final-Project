extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = -600
var flip_page = false
var pages = ["page_0", "page_1", "page_2", "page_3", "page_4", "page_5", "page_6", "page_7", \
		"page_8", "page_9", "page_10", "page_11"]
var text = []
var i = 0
var c = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Game.story_completed = false
	text = ["", $page_1/RichTextLabel.text, $page_2/RichTextLabel.text, \
			$page_3/RichTextLabel.text, $page_4/RichTextLabel.text, $page_5/RichTextLabel.text, \
			$page_6/RichTextLabel.text, $page_7/RichTextLabel.text, $page_8/RichTextLabel.text, \
			$page_9/RichTextLabel.text, $page_10/RichTextLabel.text, $page_11/RichTextLabel.text, ""]
	$page_1/RichTextLabel.text = ""
	$page_2/RichTextLabel.text = ""
	$page_3/RichTextLabel.text = ""
	$page_4/RichTextLabel.text = ""
	$page_5/RichTextLabel.text = ""
	$page_6/RichTextLabel.text = ""
	$page_7/RichTextLabel.text = ""
	$page_8/RichTextLabel.text = ""
	$page_9/RichTextLabel.text = ""
	$page_10/RichTextLabel.text = ""
	$page_11/RichTextLabel.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var page = get_node(pages[i])
	var page_text = get_node(pages[i+1]).get_child(0)
	var velocity = Vector2.ZERO
	velocity.x = speed
	page.position += velocity*delta
	if (c/4) >= text[i+1].length():
		i += 1
		if i == 11:
			Game.story_completed = true
			get_tree().change_scene("res://Main.tscn")
		else:
			c = 0
			page = get_node(pages[i])
			page_text = get_node(pages[i+1]).get_child(0)
	if c % 4 == 0 and i < 11:
		page_text.text += text[i+1][c/4]
	c += 1



func _on_Abandon_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
