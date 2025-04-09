extends Panel

@onready var player = get_tree().current_scene.find_child("Character")
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")



func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://start_screen.tscn")

func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_character_plrdied() -> void:
	animation_player.play("PlayerfadeFN")
	await animation_player.animation_finished
	get_tree().paused = true
	visible = true # Replace with function body.
	animation_player.play("FadeInDeath")
