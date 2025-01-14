extends StaticBody2D


var health = 100
var max_health = 100
var damage = 100
var phase = 0

var main
var robots
var walls
var ship

var laser_gun = load("res://Weapons.tscn")
var laserbeam = load("res://Laserbeam.tscn")
var flamethrower = load("res://Flamethrower.tscn")
var bomb = load("res://Bomb.tscn")
var wall = load("res://Wall.tscn")
var robot = load("res://Robot.tscn")

var particle_emitter = load("res://Particle_Emitter.tscn")
var particles = load("res://Particle_Emitter.tres")
var grad = load("res://robot_gradient.tres")
var hit = load("res://metal hit.mp3")
var pop = load("res://pop.mp3")

var num_robots = 0

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent().get_parent()
	robots = main.get_child(1)
	walls = main.get_child(2)
	ship = main.get_child(3)
	damage *= ((main.boss_score - 3000) / 3000)
	max_health *= ((main.boss_score - 3000) / 3000)
	health = max_health
	$"Attack Cycle".start()
	$"Phase Cycle".start()
	$"Move Cycle".start(1.75)
	$AnimatedSprite.play("Green")
	$Healthbar.min_value = 0
	$Healthbar.max_value = max_health
	$Healthbar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit(damage):
	# Create Particles
	var instance = particle_emitter.instance()
	particles.color_ramp = grad
	instance.process_material = particles
	instance.emitting = true
	instance.position = position
	instance.amount = damage * 10
	
	# Apply Damage
	health -= damage
	$Healthbar.value = health
	# Destroy self if at 0 health
	if health <= 0:
		instance.get_child(0).stream = pop
		emit_signal("destroyed", "robot", 5)
		queue_free()
	else:
		instance.get_child(0).stream = hit
	get_parent().add_child(instance)


func _on_Attack_Cycle_timeout():
	if phase == 0:
		for l in range(10):
			var instance = laser_gun.instance()
			instance.damage = damage
			instance.position = position
			robots.add_child(instance)
		$Laser.play()

	elif phase == 1:
		var instance = laserbeam.instance()
		instance.damage = damage
		instance.position.y = 340
		instance.show_behind_parent = true
		instance.scale *= 3
		add_child(instance)
	
	elif phase == 2:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var start_angle = -PI/4 + rng.randf_range(-1.0, 1.0)
		for i in range(9):
			var instance = flamethrower.instance()
			instance.damage = damage
			instance.rotation = start_angle
			instance.position = position
			robots.add_child(instance)
			start_angle += PI/16
		$Flamethrower.play()
		
	elif phase == 3:
		var instance = bomb.instance()
		instance.damage = damage
		instance.position = position
		robots.add_child(instance)


func _on_Phase_Cycle_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	phase = rng.randi_range(0,3)
	if phase == 0:
		$AnimatedSprite.play("Green")
		var instance = wall.instance()
		walls.add_child(instance)
		instance.connect("destroyed", main, "give_resources")
	elif phase == 1:
		$AnimatedSprite.play("Blue")
		if num_robots < 1:
			var instance = robot.instance()
			robots.add_child(instance)
			instance.connect("destroyed", main, "give_resources")
			instance.connect("destroyed", self, "minion_destroyed")
			num_robots += 1
	elif phase == 2:
		$AnimatedSprite.play("Red")
		var instance = wall.instance()
		walls.add_child(instance)
		instance.connect("destroyed", main, "give_resources")
	elif phase == 3:
		$AnimatedSprite.play("Purple")
		if num_robots < 1:
			var instance = robot.instance()
			robots.add_child(instance)
			instance.connect("destroyed", main, "give_resources")
			instance.connect("destroyed", self, "minion_destroyed")
			num_robots += 1

func minion_destroyed():
	num_robots -= 1

func _on_Move_Cycle_timeout():
	position.x = ship.position.x
	$"Move Cycle".wait_time = 2
