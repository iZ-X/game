extends Sprite2D

@onready var collision = $Area2D/CollisionShape2D

@export var stats : Item
@export var skill : Skill




var player_in: Player = null

func _ready():
	if stats != null:
		texture = stats.icon

func _process(delta: float) -> void:
	if player_in and Input.is_key_pressed(KEY_Q):
		pickupitem(player_in)

func pickupitem(body: Player):
	if body.has_empty_slot():
		call_deferred("reparent",body.find_child("Weapons"))
		position = body.find_child("Arm").position ## FIX THIS
		body.add_item(stats,skill)
		collision.call_deferred("set_disabled",true)
		player_in = null
		

func _on_player_entered(body: Player):
	player_in = body

func _on_player_exited(body: Player):
	if body == player_in:
		player_in = null
