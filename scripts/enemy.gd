extends CharacterBody2D
signal died

@export var speed = 100.0
@export var max_health = 1

var health = max_health
var player: Node2D

@onready var game = get_tree().current_scene

func _ready():
	print("Enemy dibuat")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		if player.is_dead:
			velocity = Vector2.ZERO
			return
		var direction = global_position.direction_to(player.global_position)

		velocity = direction * speed

		move_and_slide()

func take_damage(amount):
	health -= amount
	health = clamp(health, 0, max_health)

	hit_flash()
	print("Enemy HP:", health)

	if health <= 0:
		die()
	
func die():
	game.add_score(10)
	print("Enemy mati!")
	
	died.emit()
	queue_free()

func hit_flash():
	modulate = Color(1, 0.3, 0.3)
	$HitFlashTimer.start()


func _on_hit_flash_timer_timeout() -> void:
	modulate = Color(1, 1, 1)

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
