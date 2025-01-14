extends Node2D

# Instances
var wall = load("res://Wall.tscn")
var robot = load("res://Robot.tscn")
var jerry = load("res://Jerry.tscn")
var achievement_popup = load("res://Achievement.tscn")

var max_walls = 1
var max_robots = 1

var walls = 0
var robots = 0

# Achievement Related
var walls_broken = 0
var robots_destroyed = 0

# Jerry
var jerry_time = false
var jerry_spawned = false
var boss_score = 3000



# Called when the node enters the scene tree for the first time.
func _ready():
	Game.reset()
	$Spawner.start()
	$MusicPlayer.play()
	
	# Check if player watched story
	if Game.story_completed:
		achieved(0)
	
	# Show tutorials
	if Game.tutorials:
		$"Tips/Gold Tips".visible = true
		$Tutorial.start()



func _process(delta):
	# Update Resource Counters
	$Resources/Gold/Label.text = String(Game.gold)
	$Resources/Cannonballs/Label.text = String(Game.cannonballs)
	$Resources/Plaster/Label.text = String(Game.plaster)
	$Resources/Wood/Label.text = String(Game.wood)
	$Resources/Concrete/Label.text = String(Game.concrete)
	$Resources/Metal/Label.text = String(Game.metal)
	$Score.text = "SCORE: " + String(Game.score)
	$Highscore.text = "HIGHSCORE: " + String(Game.highscore)
	if Game.score >= boss_score:
		jerry_time = true
		boss_score += 3000
	if jerry_time and robots == 0 and walls == 0 and not jerry_spawned:
		var instance = jerry.instance()
		$Robots.add_child(instance)
		instance.connect("destroyed", self, "give_resources")
		jerry_spawned = true
	
	# Check Achievements
	if robots_destroyed >= 100 and not Game.achievements[8][2]:
		achieved(8)
	elif robots_destroyed >= 50 and not Game.achievements[6][2]:
		achieved(6)
	elif robots_destroyed >= 10 and not Game.achievements[4][2]:
		achieved(4)
	elif robots_destroyed >= 1 and not Game.achievements[2][2]:
		achieved(2)
	
	if walls_broken >= 100 and not Game.achievements[7][2]:
		achieved(7)
	elif walls_broken >= 50 and not Game.achievements[5][2]:
		achieved(5)
	elif walls_broken >= 10 and not Game.achievements[3][2]:
		achieved(3)
	elif walls_broken >= 1 and not Game.achievements[1][2]:
		achieved(1)
	
	if Game.vault_level == 5:
		if not Game.achievements[11][2]:
			achieved(11)
		if Game.mobility_level == 0 and Game.cannon_level == 0 and Game.hull_level == 0 and not Game.achievements[10][2]:
			achieved(10)
	if Game.mobility_level == 5:
		if not Game.achievements[12][2]:
			achieved(12)
		if Game.vault_level == 0 and Game.cannon_level == 0 and Game.hull_level == 0 and not Game.achievements[10][2]:
			achieved(10)
	if Game.cannon_level == 5:
		if not Game.achievements[13][2]:
			achieved(13)
		if Game.mobility_level == 0 and Game.vault_level == 0 and Game.hull_level == 0 and not Game.achievements[10][2]:
			achieved(10)
	if Game.hull_level == 5:
		if not Game.achievements[14][2]:
			achieved(14)
		if Game.mobility_level == 0 and Game.cannon_level == 0 and Game.vault_level == 0 and not Game.achievements[10][2]:
			achieved(10)
	if Game.vault_level == 5 and Game.mobility_level == 5 and Game.cannon_level == 5 \
			and Game.hull_level == 5 and not Game.achievements[15][2]:
		achieved(15)
	
	if Game.gold == 9999 and not Game.achievements[16][2]:
		achieved(16)
	if Game.cannonballs == 999 and not Game.achievements[17][2]:
		achieved(17)
	
	if Game.achievements[0][2] and Game.achievements[1][2] and Game.achievements[2][2] and Game.achievements[3][2] \
			and Game.achievements[4][2] and Game.achievements[5][2] and Game.achievements[6][2] and Game.achievements[7][2] \
			and Game.achievements[8][2] and Game.achievements[9][2] and Game.achievements[10][2] and Game.achievements[11][2] \
			and Game.achievements[12][2] and Game.achievements[13][2] and Game.achievements[14][2] and Game.achievements[15][2] \
			and Game.achievements[16][2] and Game.achievements[17][2]:
		achieved(18)

func give_resources(object_type, type):
	if object_type == "wall":
		walls -= 1
		walls_broken += 1
		# Determine wall type, give score, and randomize amounts of the appropriate resources
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		if type == 0:
			# Concrete
			Game.concrete += rng.randi_range(5,10)
			Game.score += 5
		elif type == 1:
			# Drywall
			Game.plaster += rng.randi_range(5,10)
			Game.score += 5
		elif type == 2:
			# Wood
			Game.wood += rng.randi_range(5,10)
			Game.score += 10
		elif type == 3:
			# Reinforced Wood
			Game.wood += rng.randi_range(5,10)
			rng.randomize()
			Game.concrete += rng.randi_range(2,6)
			Game.score += 20
		elif type == 4:
			# Metal
			Game.metal += rng.randi_range(5,10)
			Game.score += 50
		elif type == 5:
			# Concrete with Rebar
			Game.concrete += rng.randi_range(5,10)
			Game.metal += rng.randi_range(2,6)
			Game.score += 20
		elif type == 6:
			# Gold
			Game.gold += rng.randi_range(50,100)
			Game.score += 100
	elif object_type == "robot":
		robots -= 1
		robots_destroyed += 1
		# Give gold and score based on robot type
		if type == 0:
			Game.gold += 10
			Game.score += 10
		elif type == 1:
			Game.gold += 25
			Game.score += 25
		elif  type == 2:
			Game.gold += 50
			Game.score += 50
		elif type == 4:
			Game.gold += 50
			Game.score += 50
			# Undo the change in robot number because small purple robots do not contribute to the count
			robots += 1
		elif type == 5:
			Game.gold += 250
			Game.score += 250
			jerry_time = false
			jerry_spawned = false
			if not Game.achievements[9][2]:
				achieved(9)
	if walls < 0:
		walls = 0
	if robots < 0:
		robots = 0
	
	# Cap Resources
	if Game.gold > 9999:
		Game.gold = 9999
	if Game.plaster > 999:
		Game.plaster = 999
	if Game.wood > 999:
		Game.wood = 999
	if Game.concrete > 999:
		Game.concrete = 999
	if Game.metal > 999:
		Game.metal = 999
	if Game.cannonballs > 999:
		Game.cannonballs = 999


func _on_Timer_timeout():
	# Change max robots and walls
	if Game.wall_tutorial and Game.robot_tutorial:
		max_walls = 2
		max_robots = 3
	
	# Spawn walls or robots
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var roll = rng.randi_range(1,5)
	if roll <= (3 - walls) and walls < max_walls and not jerry_time:
		var instance = wall.instance()
		$Walls.add_child(instance)
		instance.connect("destroyed", self, "give_resources")
		walls += 1
	elif roll <= (5 - robots) and robots < max_robots and not jerry_time and Game.score >= 10:
		var instance = robot.instance()
		$Robots.add_child(instance)
		instance.connect("destroyed", self, "give_resources")
		robots += 1



func _on_Tutorial_timeout():
	if $"Tips/Gold Tips".visible:
		$"Tips/Gold Tips".visible = false
		$"Tips/Cannonball Tips".visible = true
		$Tutorial.start()
	elif $"Tips/Cannonball Tips".visible:
		$"Tips/Cannonball Tips".visible = false
		$"Tips/Resource Tips".visible = true
		$Tutorial.start()
	else:
		$Tips.visible = false


func achieved(num):
	$Achievements/AchievementSound.play()
	Game.achievements[num][2] = true
	var instance = achievement_popup.instance()
	instance.achievement_number = num
	instance.popup_mode = true
	instance.position.x = -400
	instance.position.y += (100 * $Achievements.get_child_count())
	$Achievements.add_child(instance)
