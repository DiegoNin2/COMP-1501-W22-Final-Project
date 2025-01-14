extends Node

# Score related
var score = 0
var highscore = 0

# Resources
var gold = 100
var plaster = 0
var wood = 0
var concrete = 0
var metal = 0
var cannonballs = 25

# Upgrades
var vault_level = 0
var mobility_level = 0
var cannon_level = 0
var hull_level = 0

# Tutorial Related
var tutorials = true
var robot_tutorial = false
var wall_tutorial = false
var shield_tutorial = false
var shop_tutorial = false

# Achievements Related
var achievements = [
	["True Commitment", "Watch the Entire Story", false],
	["Amateur Treasurer", "Destroy 1 Wall", false],
	["Amateur Pirate", "Destroy 1 Robot", false],
	["Novice Treasurer", "Destroy 10 Walls", false],
	["Novice Pirate", "Destroy 10 Robots", false],
	["Experienced Treasurer", "Destroy 50 Walls", false],
	["Experienced Pirate", "Destroy 50 Robots", false],
	["Professional Treasurer", "Destroy 100 Walls", false],
	["Professional Pirate", "Destroy 100 Robots", false],
	["Voyage Complete", "Defeat Jerry", false],
	["All Your Gold in One Basket", "Max Out One Stat without Upgrading Anything Else", false],
	["I Won't Lose Me Gold!", "Max Out The Vault", false],
	["Ya Won't Catch Me Jerry!", "Max Out Mobility", false],
	["Don't Get in Me Way!", "Max Out Cannons", false],
	["Me Ship Be Invincible!", "Max Out The Hull", false],
	["Unstoppable", "Max Out The Ship", false],
	["Filthy Rich", "Reach 9999 Gold", false],
	["Fully Loaded", "Reach 999 Cannonballs", false],
	["Master of the Stars", "Achieve All Other Achievements", false],
]
var story_completed = false


func reset():
	if score > highscore:
		highscore = score
	score = 0
	
	robot_tutorial = false
	wall_tutorial = false
	shield_tutorial = false
	shop_tutorial = false
	
	gold = 100
	plaster = 0
	wood = 0
	concrete = 0
	metal = 0
	cannonballs = 25
	
	vault_level = 0
	mobility_level = 0
	cannon_level = 0
	hull_level = 0
