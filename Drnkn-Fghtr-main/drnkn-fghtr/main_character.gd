class_name Player extends CharacterBody2D

@onready var hotbar: HBoxContainer = $UI/Hotbar
@onready var hitbox: Area2D = %Hitbox
@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var knockbackPower: int = 200
@onready var mob: Mob = $"../Mob"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var health: int = 100
var attacking: bool = false  # Tracks whether the player is currently attacking

enum State { NORMAL, KNOCKBACK }
var current_state: int = State.NORMAL
var knockback_timer: float = 0.0  # Timer for knockback duration

signal plrdied

func _ready() -> void:
	$Arm.set_deferred("disabled", true)
	$Hitbox.set_deferred("monitoring", false)  # Ensure hitbox starts off

	hitbox.body_entered.connect(func (body: Node) -> void:
		if body is Mob and attacking:  # Only deal damage if attacking
			body.take_damage(100)
	)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match current_state:
		State.NORMAL:
			handle_movement()
		State.KNOCKBACK:
			apply_knockback(delta)

	move_and_slide()
	
	if Input.is_action_just_pressed("punch"):
		punch()

func _input(event):
	if event.is_action_pressed("punch"):
		punch()

func punch():
	if not animation_player.is_playing():
		play_attack_animation()

func handle_movement():
	"""Handles normal movement and jumping."""
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func is_attacking() -> bool:
	return attacking  # Now correctly returns the attack state

func knockback(mob_position: Vector2):
	"""Applies knockback away from the enemy."""
	
	var knockbackDirection = (position - mob_position).normalized() * knockbackPower
	velocity = knockbackDirection
	current_state = State.KNOCKBACK
	knockback_timer = 0.3  # Knockback lasts for 0.3 seconds

func apply_knockback(delta: float):
	"""Handles knockback duration and gravity application."""
	knockback_timer -= delta
	
	# Apply gravity while in knockback
	if not is_on_floor():
		velocity += get_gravity() * delta

	if knockback_timer <= 0:
		current_state = State.NORMAL  # Return to normal movement

func take_damage(amount: int = 20):
	health -= amount
	print("damage taken:", amount)
	if health <= 0:
		die()

func die():
	plrdied.emit()

func play_attack_animation():
	attacking = true  # Set attacking state to true
	animation_player.play("punch")
	$Hitbox.set_deferred("monitoring", true)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "punch":
		attacking = false  # Reset attacking state
		$Hitbox.set_deferred("monitoring", false)  # Disable hitbox after attack ends




#
#
## HOTBAR
#
#




func add_item(stats, skill):
	hotbar.add_item(stats,skill)

@onready var weapons: Node2D = $Weapons

func has_empty_slot():
	return weapons.is_available()
