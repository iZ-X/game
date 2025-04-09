extends ProgressBar

@onready var mob: = get_tree().current_scene.find_child("Mob")
@onready var label: Label = $Label
@onready var total = get_tree().get_nodes_in_group("enemies").size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(total)
	max_value = total
	value = total
	label.text = "enemies left:" + str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "enemies left: " + str(value)


func _on_mobdied() -> void:
	value -= 1
