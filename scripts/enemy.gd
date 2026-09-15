extends CharacterBody2D
signal died

@export var speed = 100.0
@export var max_health = 1

@export var hit_sound: AudioStream
@export var death_sound: AudioStream

var health = max_health
var player: Node2D
var knockback_velocity = Vector2.ZERO
var hit_stop = false
var base_modulate = Color.WHITE
var base_scale = Vector2.ONE

@onready var game = get_tree().current_scene

func _ready():
	print("Enemy dibuat")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if hit_stop:
		velocity = Vector2.ZERO
		return
		
	if player:
		if player.is_dead:
			velocity = Vector2.ZERO
			return
		var direction = global_position.direction_to(player.global_position)

		velocity = direction * speed
		velocity += knockback_velocity
		
		knockback_velocity = knockback_velocity.move_toward(
			Vector2.ZERO,
			800.0 * delta
		)
		move_and_slide()

func take_damage(amount):
	health -= amount
	health = clamp(health, 0, max_health)

	AudioManager.play_sound(hit_sound)
	hit_flash()
	hit_scale()
	print("Enemy HP:", health)

	if health <= 0:
		die()
	
func die():
	game.add_score(10)
	print("Enemy mati!")
	
	AudioManager.play_sound(death_sound)
	
	var death_effect = preload("res://scenes/enemy_death_effect.tscn").instantiate()
	death_effect.global_position = global_position
	get_parent().add_child(death_effect)
	
	print("DEATH EFFECT SPAWN:", death_effect.global_position)
	died.emit()
	await get_tree().create_timer(0.2).timeout
	queue_free()

func hit_flash():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	modulate = Color(1, 0.3, 0.3)
	
	tween.tween_property(
		self,
		"modulate",
		base_modulate,
		0.12
	)

func hit_scale():
	var tween = create_tween()

	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	scale = base_scale * 1.12

	tween.tween_property(
	self,
	"scale",
	base_scale,
	0.1
	)
	
func set_enemy_type(type):
	if type == "tank":
		scale = Vector2(1.4, 1.4)
		modulate = Color(1, 0.4, 0.4)

	elif type == "fast":
		scale = Vector2(0.75, 0.75)
		modulate = Color(0.4, 0.7, 1.0)

	else:
		scale = Vector2(1, 1)
		modulate = Color(1, 1, 1)
	base_modulate = modulate
	base_scale = scale

func apply_knockback(direction: Vector2, force: float):
	knockback_velocity = direction.normalized() * force

func hit_stop_effect():
	hit_stop = true

	await get_tree().create_timer(0.05).timeout

	if is_inside_tree():
		hit_stop = false
