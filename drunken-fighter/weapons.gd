extends Node2D

var current_index: int = 0
var inventory = {}

func _ready():
	for i in range(3):
		inventory[i] = null

func reset():
	var weapons = get_children()
	for weapon in weapons:
		weapon.hide()

func show_weapon(index):
	#if index < get_child_count():
		#get_child(index).show()
	if inventory[index] == null:
		reset()
		return
	inventory[index].show()

func _on_index(i = current_index):
	reset()
	show_weapon(i)
	current_index = i


func _on_child_entered_tree(node):
	if is_available():
		var index = get_first_available_slot()
		inventory[index] = node
		_on_index()
	else:
		print("CANNOT!")
	
func swap(i,j):
	var temp = inventory[i]
	inventory[i] = inventory[j]
	inventory[j] = temp
	_on_index()

func is_available():
	for i in inventory:
		if inventory[i] == null:
			return true
	return false

func get_first_available_slot():
	for i in inventory:
		if inventory[i] == null:
			return i
	return -1
