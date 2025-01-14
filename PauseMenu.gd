extends Control


var is_paused = false setget set_is_paused


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
	
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	update_counters()
	
	# Show tutorials
	if is_paused and Game.tutorials and not Game.shop_tutorial:
		$Tips.visible = true
		$Tutorial.start()
		Game.shop_tutorial = true
	else:
		$Tips.visible = false


func update_counters():
	# Update Resource Counters and Upgrade Prices
	$Resources/Plaster/Label.text = String(Game.plaster)
	$Resources/Wood/Label.text = String(Game.wood)
	$Resources/Concrete/Label.text = String(Game.concrete)
	$Resources/Metal/Label.text = String(Game.metal)
	$Resources/Cannonballs/Label.text = String(Game.cannonballs)
	$Resources/Gold/Label.text = String(Game.gold)
	$Upgrades/Tiers/Vault.text = String(Game.vault_level) + "/5"
	$Upgrades/Tiers/Mobility.text = String(Game.mobility_level) + "/5"
	$Upgrades/Tiers/Cannon.text = String(Game.cannon_level) + "/5"
	$Upgrades/Tiers/Hull.text = String(Game.hull_level) + "/5"
	if Game.vault_level < 5:
		$"Upgrades/Costs/Vault/Label(P)".text = String(10 + (10 * Game.vault_level * Game.vault_level))
	else:
		$"Upgrades/Costs/Vault/Label(P)".text = "--"
	if Game.mobility_level < 5:
		$"Upgrades/Costs/Mobility/Label(W)".text = String(10 + (10 * Game.mobility_level * Game.mobility_level))
		$"Upgrades/Costs/Mobility/Label(P)".text = String(5 + (5 * Game.mobility_level * Game.mobility_level))
	else:
		$"Upgrades/Costs/Mobility/Label(W)".text = "--"
		$"Upgrades/Costs/Mobility/Label(P)".text = "--"
	if Game.cannon_level < 5:
		$"Upgrades/Costs/Cannon/Label(M)".text = String(10 + (10 * Game.cannon_level * Game.cannon_level))
		$"Upgrades/Costs/Cannon/Label(C)".text = String(5 + (5 * Game.cannon_level * Game.cannon_level))
	else:
		$"Upgrades/Costs/Cannon/Label(M)".text = "--"
		$"Upgrades/Costs/Cannon/Label(C)".text = "--"
	if Game.hull_level < 5:
		$"Upgrades/Costs/Hull/Label(W)".text = String(10 + (10 * Game.hull_level * Game.hull_level))
		$"Upgrades/Costs/Hull/Label(M)".text = String(5 + (5 * Game.hull_level * Game.hull_level))
	else:
		$"Upgrades/Costs/Hull/Label(W)".text = "--"
		$"Upgrades/Costs/Hull/Label(M)".text = "--"
	
	$"Ship Preview/HullSprite".play("forwards " + String(Game.hull_level))
	$"Ship Preview/CannonSprite".play("forwards " + String(Game.cannon_level))
	$"Ship Preview/VaultSprite".play("forwards " + String(Game.vault_level))
	$"Ship Preview/MobilitySprite".play("forwards " + String(Game.mobility_level))

# Options Tab
func _on_ResumeBtn_pressed():
	self.is_paused = false
func _on_QuitBtn_pressed():
	get_tree().quit()

	
func _on_MenuBtn_pressed():
	get_tree().change_scene("res://StartMenu.tscn")

func attempt_resource_purchase(item, payment_item, price):
	if payment_item >= price:
		item += 5
		payment_item -= price
	return [item,payment_item]
func attempt_upgrade_purchase(level, payment_item_1, payment_item_2):
	if payment_item_1 >= 10 + (10 * level * level) and payment_item_2 >= 5 + (5 * level * level) and level < 5:
		payment_item_1 -= 10 + (10 * level * level)
		payment_item_2 -= 5 + (5 * level * level)
		level += 1
	return [level, payment_item_1, payment_item_2]

func _on_BuyPlaster_pressed():
	var new_amounts = attempt_resource_purchase(Game.plaster, Game.gold, 5)
	Game.plaster = new_amounts[0]
	Game.gold = new_amounts[1]
	update_counters()
func _on_BuyWood_pressed():
	var new_amounts = attempt_resource_purchase(Game.wood, Game.gold, 10)
	Game.wood = new_amounts[0]
	Game.gold = new_amounts[1]
	update_counters()
func _on_BuyConcrete_pressed():
	var new_amounts = attempt_resource_purchase(Game.concrete, Game.gold, 25)
	Game.concrete = new_amounts[0]
	Game.gold = new_amounts[1]
	update_counters()
func _on_BuyMetal_pressed():
	var new_amounts = attempt_resource_purchase(Game.metal, Game.gold, 50)
	Game.metal = new_amounts[0]
	Game.gold = new_amounts[1]
	update_counters()
func _on_BuyCannonball_pressed():
	var new_amounts = attempt_resource_purchase(Game.cannonballs, Game.concrete, 1)
	Game.cannonballs = new_amounts[0]
	Game.concrete = new_amounts[1]
	update_counters()

func _on_UpVault_pressed():
	var new_amounts = attempt_upgrade_purchase(Game.vault_level, Game.plaster, 1000)
	Game.vault_level = new_amounts[0]
	Game.plaster = new_amounts[1]
	update_counters()
func _on_UpMobility_pressed():
	var new_amounts = attempt_upgrade_purchase(Game.mobility_level, Game.wood, Game.plaster)
	Game.mobility_level = new_amounts[0]
	Game.wood = new_amounts[1]
	Game.plaster = new_amounts[2]
	update_counters()
func _on_UpCannon_pressed():
	var new_amounts = attempt_upgrade_purchase(Game.cannon_level, Game.metal, Game.concrete)
	Game.cannon_level = new_amounts[0]
	Game.metal = new_amounts[1]
	Game.concrete = new_amounts[2]
	update_counters()
func _on_UpHull_pressed():
	var new_amounts = attempt_upgrade_purchase(Game.hull_level, Game.wood, Game.metal)
	Game.hull_level = new_amounts[0]
	Game.wood = new_amounts[1]
	Game.metal = new_amounts[2]
	update_counters()





func _on_Tutorial_timeout():
	$Tips.visible = false
