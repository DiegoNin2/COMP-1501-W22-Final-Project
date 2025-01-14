extends KinematicBody2D

# Controls the variant of wall 
# (0 = Concrete, 1 = Drywall, 2 = Wood, 3 = Reinforced Wood, 4 = Metal, 5 = Concrete with Rebar, 6 = Gold)
export var type = 0
# Stats
var health = 1
var max_health = 1
var speed = 10

var particle_emitter = load("res://Particle_Emitter.tscn")
var particles = load("res://Particle_Emitter.tres")

var drywall_grad = load("res://drywall_gradient.tres")
var wood_grad = load("res://wood_gradient.tres")
var concrete_grad = load("res://concrete_gradient.tres")
var metal_grad = load("res://metal_gradient.tres")
var gold_grad = load("res://gold_gradient.tres")

var rock_hit = load("res://rock hit.mp3")
var wood_hit = load("res://wood hit.mp3")
var metal_hit = load("res://metal hit.mp3")

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	# Shows tutorials
	if Game.tutorials and not Game.wall_tutorial:
		$Tips.visible = true
	
	# Sets the starting position for the wall
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	self.position.x = rng.randi_range(120, 630)
	self.position.y = -40
	
	# Rolls a number between 1 and 100 to determine wall type and sets stats
	rng.randomize()
	var roll = rng.randi_range(0,100)
	if roll <= 5:
		# Gold (5% Chance)
		type = 6
		max_health = 7
		$AnimatedSprite.play("gold")
	elif roll <= 15:
		# Conrete with Rebar (10% Chance)
		type = 5
		max_health = 3
		$AnimatedSprite.play("concrete with rebar")
	elif roll <= 30:
		# Metal (15% Chance)
		type = 4
		max_health = 5
		$AnimatedSprite.play("metal")
	elif roll <= 45:
		# Reinforced Wood (15% Chance)
		type = 3
		max_health = 3
		$AnimatedSprite.play("reinforced wood")
	elif roll <= 65:
		# Wood (20% Chance)
		type = 2
		max_health = 2
		$AnimatedSprite.play("wood")
	elif roll <= 85:
		# Drywall (20% Chance)
		type = 1
		max_health = 1
		$AnimatedSprite.play("drywall")
	else:
		# Concrete (25% Chance)
		type = 0
		max_health = 1
		$AnimatedSprite.play("concrete")
	health = max_health
	$Healthbar.min_value = 0
	$Healthbar.max_value = max_health
	$Healthbar.value = health
	# Randomizes speed
	rng.randomize()
	speed = rng.randi_range(10, 50)



func _process(delta):
	var velocity = Vector2.ZERO
	velocity.y = speed
		
	position += velocity * delta
	if position.y > 1000:
		emit_signal("destroyed", "wall", 7)
		queue_free()

func hit(damage):
	# Create Particles
	var instance = particle_emitter.instance()
	if type == 1:
		particles.color_ramp = drywall_grad
		instance.get_child(0).stream = wood_hit
	elif type == 2 or type == 3:
		particles.color_ramp = wood_grad
		instance.get_child(0).stream = wood_hit
	elif type == 0 or type == 5:
		particles.color_ramp = concrete_grad
		instance.get_child(0).stream = rock_hit
	elif type == 4:
		particles.color_ramp = metal_grad
		instance.get_child(0).stream = metal_hit
	else:
		particles.color_ramp = gold_grad
		instance.get_child(0).stream = metal_hit
	instance.process_material = particles
	instance.emitting = true
	instance.position = position
	instance.amount = damage * 10
	get_parent().add_child(instance)
	
	
	# Apply Damage
	health -= damage
	$Healthbar.value = health
	# Destroy self if at 0 health
	if health <= 0:
		emit_signal("destroyed", "wall", type)
		Game.wall_tutorial = true
		queue_free()
