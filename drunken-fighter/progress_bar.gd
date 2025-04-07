extends ProgressBar

@onready var character: Player = $"../.."
@onready var label: Label = $Label

func _ready() -> void:
	max_value = character.health
	label.text = "Health: " + str(value)

func _process(delta: float) -> void:
	value = character.health
	label.text = "Health: " + str(value)
