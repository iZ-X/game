extends Node2D

@onready var pause_screen: Control = $PauseScreen
var paused = false
@onready var character: Player = $Character



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	character.find_child("UI").visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseScreen()


func pauseScreen():
	if paused:
		pause_screen.hide()
		Engine.time_scale = 1
	else:
		pause_screen.show()
		Engine.time_scale = 0
		
	paused = !paused
