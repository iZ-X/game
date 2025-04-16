extends Button
class_name Slot

## https://www.youtube.com/watch?v=DaZsCPuDJ5c
@onready var player = get_tree().current_scene.find_child("Character")
@onready var AURA = preload("res://Resources/Skills/Aura.tres")
@onready var STAB = preload("res://Resources/Skills/Stab.tres")
@onready var test = load("res://Skill.gd")
@onready var mobs: = get_tree().get_nodes_in_group("enemies")

@export var stats: Item = null:
	set(value):
		# Make a duplicate of the resource to ensure unique durability
		if value != null:
			stats = value.duplicate()
			icon = stats.icon
		else:
			stats = null
			icon = null
			
@export var skill: Skill = null


func _ready() -> void:
	set_process_input(false)
	set_process(false)  # Start with process disabled
	# Connect to the hotbar's index signal
	get_parent().index.connect(_on_hotbar_index)
	
	# Check if this slot is initially selected
	if get_parent().current_index == get_index():
		update_mob_damage()

# Function to check if this slot is selected and update damage
func _on_hotbar_index(index: int) -> void:
	if index == get_index():
		update_mob_damage()

# Function to update mob damage based on the current item
func update_mob_damage() -> void:
	if stats != null and "knife" in stats.name.to_lower(): ## CHANGE KNIFE TO WHATEVER ITEM IS IN THE ABSTRACTITEM YOU WANT TO CHANGE BUFFS OF
		# Set damage value for all mobs in the scene
		for mob in get_tree().get_nodes_in_group("enemies"):
			mob.dmg = 50
		print("Knife selected! Mob damage set to: 50")
	else:
		# Reset damage to default value for all mobs
		for mob in get_tree().get_nodes_in_group("enemies"):
			mob.dmg = 5
		print("Non-knife item selected! Mob damage reset to: 5")

func remove_item():
	var weaponHolder = player.find_child("Weapons")
	var itm = weaponHolder.find_child("*AbstractItem*", true)
	if itm:
		itm.queue_free()

func _process(delta: float) -> void:
	# Continuously check if punch is pressed when STAB skill is active
	if skill == STAB and stats and stats.durability > 0:
		if Input.is_action_pressed("punch"):
			player.apply_skill_enhancement("STAB")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		use_item()
		
	# Enable process monitoring when relevant skill is active
	if skill == STAB and stats and stats.durability > 0:
		set_process(true)
	else:
		set_process(false)

"""CHANGE DURABILITY IN INSPECTOR NOT IN THE CODE!"""

func use_item():
	
	if stats == null:
		return	
	print("Used")
	
	# Reduce durability when item is used
	if stats.durability > 0:
		stats.durability -= 1
		print(str(stats.durability))
		
		# Check if item is broken
		if stats.durability <= 0:
			remove_item()
			stats = null
			skill = null
			set_process(false)  # Make sure processing stops if item breaks
			return

	match skill: ## ADD ANY NEW THINGS
		AURA:
			player.SPEED = 500.0
			print(player.SPEED)
			print("JJJ")
		STAB:
			# Just activate the skill, the _process function will handle punching
			player.health = 100.0
			print("STAB skill ready")



func _on_pressed() -> void:
	use_item()
	# Clear any existing skill enhancement when changing slots
	player.clear_skill_enhancement()
	get_parent().current_index = get_index()
	player.find_child("Weapons")._on_index(get_index())
	
	# No need to update mob damage here as it will be handled by the index signal

# Function to properly set an item with a custom durability
func set_item(item: Item, custom_durability: int = -1, item_skill: Skill = null) -> void:
	stats = item # This calls the setter which duplicates the item
	
	if custom_durability > 0:
		stats.durability = custom_durability
		
	if item_skill:
		skill = item_skill
		
	# Update mob damage based on this item
	if get_parent().current_index == get_index():
		update_mob_damage()
