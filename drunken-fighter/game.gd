extends Node2D

@onready var pause_screen: Control = $PauseScreen
var paused = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
