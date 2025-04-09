extends Control


@onready var pause_screen: Control = $"."

@onready var game = $"../../"

func _on_resume_pressed() -> void:
	pause_screen.hide()
	Engine.time_scale = 1


func _on_quit_pressed() -> void:
	get_tree().quit()
