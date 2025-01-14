extends KinematicBody2D

var screen_size
const SPEED = 100
var cannonball = load("res://Cannonball.tscn")
var can_shoot = true

# Tutorial Stuff
var moved = false
var shot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Show Tutorials
	if Game.tutorials:
		$Tips.visible = true
		
	
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Moves the Player left and right
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		moved = true
		velocity.x = -(SPEED + (Game.mobility_level * 25))
		$HullSprite.play("left " + String(Game.hull_level))
		$CannonSprite.play("left " + String(Game.cannon_level))
		$VaultSprite.play("left " + String(Game.vault_level))
		$MobilitySprite.play("left " + String(Game.mobility_level))
	elif Input.is_action_pressed("ui_right"):
		moved = true
		velocity.x = (SPEED + (Game.mobility_level * 25))
		$HullSprite.play("right " + String(Game.hull_level))
		$CannonSprite.play("right " + String(Game.cannon_level))
		$VaultSprite.play("right " + String(Game.vault_level))
		$MobilitySprite.play("right " + String(Game.mobility_level))
	else:
		$HullSprite.play("forwards " + String(Game.hull_level))
		$CannonSprite.play("forwards " + String(Game.cannon_level))
		$VaultSprite.play("forwards " + String(Game.vault_level))
		$MobilitySprite.play("forwards " + String(Game.mobility_level))
	
	move_and_slide(velocity)
	velocity.x = lerp(velocity.x, 0, 0.1)
	
	position += velocity * delta
	position.x = clamp(position.x,0,screen_size.x)
	
	# Shoots a cannonball when the player presses space
	if Input.is_action_just_pressed("ui_select") and Game.cannonballs > 0 and can_shoot:
		shot = true
		var instance = cannonball.instance()
		add_child(instance)
		Game.cannonballs -= 1
		can_shoot = false
		$Cannonfire.play()
		$Reload.wait_time = 2 - (0.25 * Game.mobility_level)
		$Reload.start()
	
	$Line2D.look_at(get_global_mouse_position())
	
	# Craft Cannonballs by Pressing c
	if Input.is_action_just_pressed("craft") and Game.concrete >= 1:
		Game.concrete -= 1
		Game.cannonballs += 5
	
	if Game.gold <= 0:
		get_tree().change_scene("res://Game Over.tscn")
		
	# Stop Showing Tutorials
	if moved and shot:
		$Tips.visible = false


func hit(damage):
	# Apply Damage based on hull level
	damage = int(damage * (1.0 - (Game.hull_level / 10.0)))
	Game.gold -= damage
	$Particles.amount = damage
	$Particles.emitting = true
	$Coins.play()



func _on_Reload_timeout():
	can_shoot = true
	


func _on_Drain_timeout():
	Game.gold -= 1
	$Drain.wait_time = 1 + (0.5 * Game.vault_level)
	$Drain.start()
