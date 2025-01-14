extends KinematicBody2D


# Controls the variant of robot 
# (0 = Green, 1 = Blue, 2 = Red, 3 = Purple, 4 = Small Purple)
export var type = 0

var laser_gun = load("res://Weapons.tscn")
var laserbeam = load("res://Laserbeam.tscn")
var flamethrower = load("res://Flamethrower.tscn")
var bomb = load("res://Bomb.tscn")
var shield_generator = load("res://ShieldGenerator.tscn")
var small_bomb = load("res://Small_Bomb.tscn")

var particle_emitter = load("res://Particle_Emitter.tscn")
var particles = load("res://Particle_Emitter.tres")
var grad = load("res://robot_gradient.tres")
var hit = load("res://metal hit.mp3")
var pop = load("res://pop.mp3")
# Stats
var health = 1
var max_health = 1
var damage = 1
var speed = 25

var roll_modifier = 0

var can_hit = true

signal destroyed


# Called when the node enters the scene tree for the first time.
func _ready():
	# Show tutorials
	if Game.tutorials and not Game.robot_tutorial:
		$Tips.visible = true
	
	roll_modifier = floor((Game.score - 2000) / 100)
	var rng = RandomNumberGenerator.new()
	if type != 4:
		# Sets the starting position for the robot
		rng.randomize()
		self.position.x = rng.randi_range(36, 714)
		self.position.y = 68
		
		# Rolls a number between 1 and 100 to determine robot type and sets stats
		rng.randomize()
		var roll = rng.randi_range(0,100)
		if roll <= 5 + roll_modifier and Game.score >= 2000:
			# Purple
			type = 3
			max_health = 10
			damage = 200
			$AnimatedSprite.play("Purple")
			$Bomb_Timer.start()
			speed = 15
		elif roll <= 20 + roll_modifier and Game.score >= 1000:
			# Red
			type = 2
			max_health = 10
			damage = 100
			$AnimatedSprite.play("Red")
			$Flame_Timer.start()
			speed = 50
		elif roll <= 50 + roll_modifier and Game.score >= 250:
			# Blue
			type = 1
			max_health = 4
			damage = 50
			can_hit = false
			$AnimatedSprite.play("Blue (Shield)")
			$Laser_Timer.start()
			var instance = shield_generator.instance()
			instance.connect("destroyed", self, "shield_destroyed")
			get_parent().add_child(instance)
			speed = 75
		else:
			# Green
			type = 0
			max_health = 2
			damage = 5
			$AnimatedSprite.play("Green")
			$Shoot_Timer.start()
		# Randomize Initial Direction
		rng.randomize()
		if rng.randi_range(0,1) == 1:
			speed *= -1
	else:
		max_health = 3
		damage = 50
		$AnimatedSprite.play("Small Purple")
		$Small_Bomb_Timer.start()
		speed = 75
	health = max_health
	$Healthbar.min_value = 0
	$Healthbar.max_value = max_health
	$Healthbar.value = health
	



func _process(delta):
	# Movement
	if position.x < 36:
		speed = abs(speed)
	elif position.x > 714:
		speed = abs(speed) * -1
	var velocity = Vector2.ZERO
	velocity.x = speed
	position += velocity * delta

func hit(damage):
	# Create Particles
	var instance = particle_emitter.instance()
	particles.color_ramp = grad
	instance.process_material = particles
	instance.emitting = true
	instance.position = position
	instance.amount = damage * 10
	
	# Apply Damage
	if can_hit:
		health -= damage
		$Healthbar.value = health
		instance.amount = damage * 10
	# Destroy self if at 0 health
	if health <= 0:
		instance.get_child(0).stream = pop
		Game.robot_tutorial = true
		emit_signal("destroyed", "robot", type)
		# Create 3 small purple robots on death
		if type == 3:
			var robot = load("res://Robot.tscn")
			for i in range(-96, 96, 64):
				instance = robot.instance()
				instance.type = 4
				instance.speed = speed
				instance.position.x = position.x + i
				instance.position.y = 68
				get_parent().add_child(instance)
				instance.connect("destroyed", get_parent().get_parent(), "give_resources")
		queue_free()
	else:
		instance.get_child(0).stream = hit
	if can_hit:
		get_parent().add_child(instance)

func shield_destroyed():
	can_hit = true
	$AnimatedSprite.play("Blue (No Shield)")

func _on_Shoot_Timer_timeout():
	var instance = laser_gun.instance()
	instance.damage = damage
	instance.position = position
	get_parent().add_child(instance)
	$Laser.play()


func _on_Laser_Timer_timeout():
	var instance = laserbeam.instance()
	instance.damage = damage
	add_child(instance)


func _on_Flame_Timer_timeout():
	var start_angle = -PI/8
	for i in range(5):
		var instance = flamethrower.instance()
		instance.damage = damage
		instance.rotation = start_angle
		instance.position = position
		get_parent().add_child(instance)
		start_angle += PI/16
	$Flamethrower.play()


func _on_Bomb_Timer_timeout():
	var instance = bomb.instance()
	instance.damage = damage
	instance.position = position
	get_parent().add_child(instance)



func _on_Small_Bomb_Timer_timeout():
	var instance = small_bomb.instance()
	instance.damage = damage
	instance.position = position
	get_parent().add_child(instance)
