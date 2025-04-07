class_name Mob extends CharacterBody2D

@onready var target = $"../Character"
var health: int = 100
const speed = 120.0
const GRAVITY = 980.0
@onready var hitbox: Area2D = $Hitbox
@onready var knockbackPower: int = 500
var is_dead = false
enum State { CHASING, KNOCKBACK }
var current_state: int = State.CHASING  # Start in chasing mode
var knockback_timer: float = 0.0  # Timer for knockback duration
@onready var mob_healthbar: ProgressBar = $mobHealthbar
@onready var animation_player: AnimationPlayer = $mobHealthbar/AnimationPlayer
@export var dmg:int = 5

signal mobdied
signal mobhit

func _ready() -> void:
	mob_healthbar.self_modulate.a = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	
	match current_state:
		State.CHASING:
			chase_player()
		State.KNOCKBACK:
			apply_knockback(delta)

	move_and_slide()
	
	
func take_damage(amount:int):
	
	mobhit.emit()
	
	
	
	if is_dead: 
		return
	health -= dmg
	print("Mob took ", amount, " damage! Health:", health)

	if health <= 0:
		is_dead = true
		mobdied.emit()
		set_deferred("monitoring", false)  
		queue_free()


func chase_player():

	
	if target and is_instance_valid(target):
		var direction = (target.position - position).normalized()
		velocity.x = direction.x * speed
	else:
		get_tree().quit()

func knockback():
	var knockbackDirection = (position - target.position).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	
	current_state = State.KNOCKBACK
	knockback_timer = 0.3

func apply_knockback(delta: float):
	if not is_inside_tree():  
		return
	knockback_timer -= delta
	
	# Apply gravity while in knockback state
	if not is_on_floor():
		velocity += get_gravity() * delta  # Ensures mob falls normally

	if knockback_timer <= 0:
		current_state = State.CHASING  # Return to chasing mode



func _on_hitbox_body_entered(body: Node) -> void:
	if not $Hitbox.monitoring:
		return
		

	if body is Player:
		var player := body as Player
		if not player.is_attacking():
			player.take_damage()
		if player.is_attacking():
			HitStopManager.hit_stop_short()
			knockback()
		$Hitbox.set_deferred("monitoring", false)
		await get_tree().create_timer(0.5).timeout
		$Hitbox.set_deferred("monitoring", true)
